// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/animation_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/mail_send_dialog.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/presentation/components/text_field.dart';
import 'package:chat/presentation/components/validation.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:chat/utils/converter/email_x_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailInputController = useTextEditingController(); //Button Animation
    final isLoading = useState(false);
    final isDone = useState(false);
    final isError = useState(false);
    final btnText = useState('Send');
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
          'Forgot Password',
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
                      Assets.images.forgotPassword,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Reset Password',
                      style: commonTextStyle(
                        size: 28,
                        weight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  commonTextField(
                    labelText: 'Mail Address',
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    validator: (value) {
                      return value!.isEmpty
                          ? 'Mail Address is a required field'
                          : value.isValidEmail
                              ? null
                              : 'Invalid Mail Address';
                    },
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Please enter the email address you\'d like your password reset information sent to',
                    style: commonTextStyle(
                      size: 13,
                      color: AppColor.greyTextColor,
                      weight: FontWeight.w400,
                    ),
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
                              try {
                                isLoading.value = true;
                                FocusManager.instance.primaryFocus?.unfocus();
                                await authStateNotifier.forgotPassword(
                                  emailInputController.text,
                                );
                                isDone.value = true;
                                final mail =
                                    emailXConverter(emailInputController.text);
                                Timer(
                                  const Duration(milliseconds: 500),
                                  () async => {
                                    isLoading.value = false,
                                    isDone.value = false,
                                    btnText.value = 'Send',
                                    btnAnimationController.reset(),
                                    await showDialogBox(
                                      context,
                                      'We have sent an email to reset your password.',
                                      'A password reset email has been sent to $mail. To complete your password reset process , please click the link in the email within 48 hours and change the password.',
                                    ),
                                  },
                                );
                              } on FirebaseException catch (e) {
                                if (e.message != null) {
                                  isError.value = true;
                                  Timer(
                                    const Duration(seconds: 1),
                                    () => {
                                      isLoading.value = false,
                                      isError.value = false,
                                      btnText.value = 'Send',
                                      btnAnimationController.reverse(),
                                    },
                                  );
                                  if (e.message != null) {
                                    showSnackBar(
                                        context,
                                        e.code == 'user-not-found'
                                            ? 'User does not exist'
                                            : e.message.toString());
                                  }
                                }
                              }
                            }
                          },
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
