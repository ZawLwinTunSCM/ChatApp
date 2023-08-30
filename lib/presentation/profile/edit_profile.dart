// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:typed_data';
import 'package:chat/constants/app_color.dart';
import 'package:chat/entities/user.dart';
import 'package:chat/presentation/components/auth_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/text_field.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends HookConsumerWidget {
  const EditProfilePage({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameInputController = useTextEditingController(text: user.name);
    final addressInputController = useTextEditingController(text: user.address);
    final phoneInputController = useTextEditingController(text: user.phone);
    final emailInputController = useTextEditingController(text: user.email);
    final profilePhotoInputController =
        useTextEditingController(text: user.profilePhoto);

    final profileImage = useState<Uint8List?>(null);

    Future<Uint8List?> imagePicker() async {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null) {
        return null;
      }
      final mimeType = lookupMimeType(image.name);
      if (mimeType == null || mimeType.split('/')[0] != 'image') {
        return null;
      }
      return image.readAsBytes();
    }

    Future<void> pickImage() async {
      final imageBytes = await imagePicker();
      if (imageBytes != null) {
        profileImage.value = imageBytes;
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Profile',
          style: commonTextStyle(size: 20),
        ),
        hasBackButton: true,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              InkWell(
                onTap: pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    profileImage.value != null
                        ? CircleAvatar(
                            maxRadius: 100,
                            backgroundImage: MemoryImage(profileImage.value!),
                          )
                        : CircleAvatar(
                            maxRadius: 100,
                            backgroundImage: NetworkImage(user.profilePhoto),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              commonTextField(
                labelText: 'Mail Address',
                controller: emailInputController,
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                suffixIcon: const Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              commonTextField(
                labelText: 'User Name',
                controller: nameInputController,
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                validator: (value) {
                  print('===============+$value===============');
                  return value!.isEmpty
                      ? 'User Name is a required field'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              commonTextField(
                labelText: 'Phone',
                controller: phoneInputController,
                prefixIcon: const Icon(Icons.phone, color: Colors.white),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              commonTextField(
                  labelText: 'Address',
                  controller: addressInputController,
                  prefixIcon:
                      const Icon(Icons.location_city, color: Colors.white),
                  keyboardType: TextInputType.streetAddress),
              const SizedBox(height: 15),
              AuthButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (profileImage.value != null) {
                        final imageUrl =
                            await authStateNotifier.updateProfilePhoto(
                                userId: user.id,
                                imageBytes: profileImage.value!);
                        profilePhotoInputController.text = imageUrl;
                      }
                      await authStateNotifier.updateProfile(
                          user: User(
                              id: user.id,
                              name: nameInputController.text,
                              email: emailInputController.text,
                              phone: phoneInputController.text,
                              address: addressInputController.text,
                              profilePhoto: profilePhotoInputController.text,
                              createdAt: user.createdAt));
                      Navigator.pop(context);
                    }
                  },
                  color: AppColor.darkPurple,
                  child: Text(
                    'Update Profile',
                    style: commonTextStyle(size: 16, weight: FontWeight.w400),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
