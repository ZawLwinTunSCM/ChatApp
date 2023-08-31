import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:flutter/material.dart';

Widget settingButton(
    {required Widget icon, required String text, void Function()? onClick}) {
  return Container(
    decoration: const BoxDecoration(
      border: Border.symmetric(
        horizontal: BorderSide(color: AppColor.greyBorderColor, width: 1),
      ),
    ),
    child: InkWell(
      onTap: onClick ?? () {},
      splashColor: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: icon),
            const SizedBox(width: 20),
            Expanded(
              flex: 9,
              child: Text(
                text,
                style: commonTextStyle(size: 15, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
