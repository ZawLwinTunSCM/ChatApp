// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat/assets/assets.gen.dart';
import 'package:chat/presentation/components/animation_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/presentation/components/text_field.dart';
import 'package:chat/presentation/components/validation.dart';
import 'package:chat/presentation/profile/profile_page.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final currentPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmNewPasswordController = useTextEditingController();
    final isObscureCurrentPassword = useState(true);
    final isObscureNewPassword = useState(true);
    final isObscureConfirmPassword = useState(true);
    //Button Animation
    final isLoading = useState(false);
    final isDone = useState(false);
    final isError = useState(false);
    final btnText = useState('Change Password');
    final width = MediaQuery.of(context).size.width;
    final btnAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 500));
    final widthAnimation = useAnimation(
      Tween(begin: width, end: 48.5).animate(
        CurvedAnimation(
          parent: btnAnimationController,
          curve: Curves.linear,
        ),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Change Password',
          style: commonTextStyle(size: 20),
        ),
        hasBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: SvgPicture.asset(
                      Assets.images.passwordChange,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Change Password',
                      style: commonTextStyle(
                        size: 28,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  commonTextField(
                    labelText: 'Current Password',
                    controller: currentPasswordController,
                    isObscureText: isObscureCurrentPassword,
                    prefixIcon: const Icon(Icons.password, color: Colors.white),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isObscureCurrentPassword.value =
                            !isObscureCurrentPassword.value;
                      },
                      child: Icon(
                        isObscureCurrentPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Password is a required field'
                          : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  commonTextField(
                    labelText: 'New Password',
                    controller: newPasswordController,
                    isObscureText: isObscureNewPassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: const Icon(Icons.password, color: Colors.white),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isObscureNewPassword.value =
                            !isObscureNewPassword.value;
                      },
                      child: Icon(
                        isObscureNewPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Password is a required field'
                          : value.isValidPassword
                              ? null
                              : 'Invalid Password (minimum length : 8 , one capital letter,'
                                  '\none small letter, one number, and one special character)';
                    },
                  ),
                  const SizedBox(height: 12),
                  commonTextField(
                    labelText: 'Confirm New Password',
                    controller: confirmNewPasswordController,
                    isObscureText: isObscureConfirmPassword,
                    prefixIcon: const Icon(Icons.password, color: Colors.white),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        isObscureConfirmPassword.value =
                            !isObscureConfirmPassword.value;
                      },
                      child: Icon(
                        isObscureConfirmPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                    ),
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Password is a required field'
                          : newPasswordController.text.isValidPassword
                              ? value == newPasswordController.text
                                  ? null
                                  : 'Password Confirmation does not match'
                              : null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading.value
                      ? loadingButton(
                          isDone: isDone.value,
                          isError: isError.value,
                        )
                      : actionButton(
                          width: width,
                          widthAnimation: widthAnimation,
                          btnText: btnText.value,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              btnText.value = '';
                              await btnAnimationController.forward();
                              isLoading.value = true;
                              final check =
                                  await authStateNotifier.checkPassword(
                                      currentPassword:
                                          currentPasswordController.text);
                              if (check) {
                                isDone.value = true;
                                authStateNotifier.changePassword(
                                    currentPassword:
                                        currentPasswordController.text,
                                    newPassword: newPasswordController.text);
                                Navigator.of(context).pushAndRemoveUntil<void>(
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                isError.value = true;
                                Timer(
                                  const Duration(seconds: 1),
                                  () => {
                                    isLoading.value = false,
                                    isError.value = false,
                                    btnText.value = 'Sign Up',
                                    btnAnimationController.reverse()
                                  },
                                );
                                showSnackBar(
                                    context, 'Current Password is incorrect');
                              }
                            }
                          })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
