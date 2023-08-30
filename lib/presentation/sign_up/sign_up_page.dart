// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat/assets/assets.gen.dart';
import 'package:chat/presentation/components/animation_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/mail_send_dialog.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/presentation/components/social_button.dart';
import 'package:chat/presentation/components/text_field.dart';
import 'package:chat/presentation/components/validation.dart';
import 'package:chat/presentation/login/login_page.dart';
import 'package:chat/presentation/main/main_page.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:chat/utils/converter/email_x_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailInputController = useTextEditingController();
    final passwordInputController = useTextEditingController();
    final nameInputController = useTextEditingController();
    final isObscureText = useState(true);
    //Button Animation
    final isLoading = useState(false);
    final isDone = useState(false);
    final isError = useState(false);
    final btnText = useState('Sign Up');
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      child: SvgPicture.asset(
                        Assets.images.register,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Sign Up',
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
                    const SizedBox(height: 12),
                    commonTextField(
                      labelText: 'Password',
                      controller: passwordInputController,
                      isObscureText: isObscureText,
                      prefixIcon:
                          const Icon(Icons.password, color: Colors.white),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          isObscureText.value = !isObscureText.value;
                        },
                        child: Icon(
                          isObscureText.value
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
                      labelText: 'User Name',
                      controller: nameInputController,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      validator: (value) {
                        return value!.isEmpty
                            ? 'User Name is a required field'
                            : null;
                      },
                    ),
                    const SizedBox(height: 12),
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
                                  await authStateNotifier.signUp(
                                    emailInputController.text,
                                    passwordInputController.text,
                                    nameInputController.text,
                                  );
                                  isDone.value = true;
                                  final mail = emailXConverter(
                                      emailInputController.text);
                                  Timer(
                                    const Duration(milliseconds: 500),
                                    () async => {
                                      isLoading.value = false,
                                      isDone.value = false,
                                      btnText.value = 'Sign Up',
                                      btnAnimationController.reset(),
                                      await showDialogBox(
                                        context,
                                        'We have sent a verification email.',
                                        'A confirmation email has been sent to $mail. To complete your account registration, please click the link in the email within 72 hours to approve your account and log in.',
                                      ),
                                    },
                                  );
                                } on FirebaseException catch (e) {
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
                                  if (e.message != null) {
                                    showSnackBar(
                                      context,
                                      e.message.toString(),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                    const SizedBox(height: 41),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _commonDivider(
                          18,
                          5,
                          true,
                        ),
                        Text(
                          'OR',
                          style: commonTextStyle(
                              size: 13, weight: FontWeight.w400),
                        ),
                        _commonDivider(
                          18,
                          5,
                          false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialButton(
                          onPressed: () async {
                            try {
                              await authStateNotifier.googleSignIn();
                              await Navigator.of(context)
                                  .pushAndRemoveUntil<void>(
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                                (route) => false,
                              );
                            } on FirebaseException catch (e) {
                              if (e.message != null) {
                                showSnackBar(
                                  context,
                                  e.message.toString(),
                                );
                              }
                            }
                          },
                          child: SvgPicture.asset(
                            Assets.images.socialGoogle,
                          ),
                        ),
                        const SizedBox(width: 38),
                        socialButton(
                          onPressed: () async {
                            try {
                              await authStateNotifier.facebookSignIn();
                              await Navigator.of(context)
                                  .pushAndRemoveUntil<void>(
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                                (route) => false,
                              );
                            } on FirebaseException catch (e) {
                              if (e.message != null) {
                                showSnackBar(
                                  context,
                                  e.message.toString(),
                                );
                              }
                            }
                          },
                          child: SvgPicture.asset(
                            Assets.images.socialFacebook,
                          ),
                        ),
                        const SizedBox(width: 38),
                        socialButton(
                          onPressed: () async {
                            try {
                              await authStateNotifier.twitterSignIn();
                              await Navigator.of(context)
                                  .pushAndRemoveUntil<void>(
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                                (route) => false,
                              );
                            } on FirebaseException catch (e) {
                              if (e.message != null) {
                                showSnackBar(
                                  context,
                                  e.message.toString(),
                                );
                              }
                            }
                          },
                          child: SvgPicture.asset(
                            Assets.images.socialTwitter,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil<void>(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Already have an account?',
                        style: commonTextStyle(
                          size: 13,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Expanded _commonDivider(double width, double padding, bool right) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.only(top: padding),
      child: Divider(
        color: const Color(0xFFD7D7D7),
        thickness: 1,
        endIndent: right ? width : 0,
        indent: !right ? width : 0,
      ),
    ),
  );
}
