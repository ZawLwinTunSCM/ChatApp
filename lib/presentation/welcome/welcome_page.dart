import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/login/login_page.dart';
import 'package:chat/presentation/components/auth_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: AppColor.dark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
              ),
              child: Assets.images.splash.image(),
            ),
            const SizedBox(height: 50),
            Container(
              margin: _commonMargin(),
              child: AuthButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                color: AppColor.darkPurple,
                child: Text(
                  'Login',
                  style: commonTextStyle(size: 16, weight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Container(
              margin: _commonMargin(),
              child: AuthButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil<void>(
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                    (route) => false,
                  );
                },
                color: AppColor.darkPurple,
                child: Text(
                  'Sign Up',
                  style: commonTextStyle(size: 16, weight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

EdgeInsetsGeometry _commonMargin() {
  return const EdgeInsets.only(
    left: 24,
    right: 24,
  );
}
