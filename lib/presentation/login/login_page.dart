// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:chat/assets/assets.gen.dart';
import 'package:chat/presentation/components/animation_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/presentation/components/social_button.dart';
import 'package:chat/presentation/components/text_field.dart';
import 'package:chat/presentation/forgot_password/forgot_password_page.dart';
import 'package:chat/presentation/main/main_page.dart';
import 'package:chat/presentation/sign_up/sign_up_page.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.watch(authStateNotifierProvider.notifier);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailInputController = useTextEditingController();
    final passwordInputController = useTextEditingController();
    final isObscureText = useState(true);
    //Button Animation
    final isLoading = useState(false);
    final isDone = useState(false);
    final isError = useState(false);
    final btnText = useState('Login');
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
                        Assets.images.login,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        style:
                            commonTextStyle(size: 28, weight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
                    commonTextField(
                      true,
                      labelText: 'Mail Address',
                      controller: emailInputController,
                      isObscureText: isObscureText,
                    ),
                    const SizedBox(height: 13),
                    commonTextField(
                      true,
                      labelText: 'Password',
                      controller: passwordInputController,
                      isObscureText: isObscureText,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage(),
                            ),
                          );
                          formKey.currentState?.reset();
                        },
                        child: Text(
                          'Forgot your password?',
                          style: commonTextStyle(
                            size: 13,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  await authStateNotifier.signIn(
                                    emailInputController.text,
                                    passwordInputController.text,
                                  );
                                  isDone.value = true;
                                  Timer(
                                    const Duration(milliseconds: 1000),
                                    () async => await Navigator.of(context)
                                        .pushAndRemoveUntil<void>(
                                      MaterialPageRoute(
                                        builder: (context) => const MainPage(),
                                      ),
                                      (route) => false,
                                    ),
                                  );
                                } on FirebaseException catch (e) {
                                  isError.value = true;
                                  Timer(
                                    const Duration(seconds: 1),
                                    () => {
                                      isLoading.value = false,
                                      isError.value = false,
                                      btnText.value = 'Login',
                                      btnAnimationController.reverse(),
                                    },
                                  );
                                  if (e.message != null) {
                                    showSnackBar(
                                      context,
                                      _errorMsg(e.code),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil<void>(
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Click here if you are a first time user',
                        style:
                            commonTextStyle(size: 13, weight: FontWeight.w400),
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

String _errorMsg(String e) {
  switch (e) {
    case 'user-not-found':
      return 'User does not exist';
    case 'user-disabled':
      return 'User is disabled';
    case 'too-many-requests':
      return 'Login Failed. Please try again later';
    case 'operation-not-allowed':
      return 'Login is not allowed. Please contact your administrator';
    case 'not_verify_email':
      return 'Please verify your email first and try again';
    default:
      return 'Email or Password is not correct';
  }
}
