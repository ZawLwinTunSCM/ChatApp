import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/auth_button.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<bool> showDialogBox(
    BuildContext context, String title, String text) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                const SizedBox(height: 5),
                SvgPicture.asset(
                  Assets.images.mailSend,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 21),
                  child: Text(
                    title,
                    style: commonTextStyle(
                      size: 28,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 38, right: 36),
                  child: Text(
                    text,
                    style: commonTextStyle(
                      size: 14,
                      weight: FontWeight.w200,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
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
                        style:
                            commonTextStyle(size: 16, weight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        },
      ) ??
      false;
}
