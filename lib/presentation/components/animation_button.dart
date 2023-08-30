import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:flutter/material.dart';

Widget loadingButton({required bool isDone, required bool isError}) {
  final color = isDone
      ? Colors.green
      : isError
          ? Colors.red
          : AppColor.darkPurple;
  return Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: Center(
      child: isDone
          ? const Icon(
              Icons.done,
              size: 40,
              color: Colors.white,
            )
          : isError
              ? const Icon(
                  Icons.close,
                  size: 36,
                  color: Colors.white,
                )
              : const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
    ),
  );
}

Widget actionButton({
  required double width,
  required double widthAnimation,
  required String btnText,
  required void Function() onTap,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(vertical: 10),
      backgroundColor: AppColor.darkPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          widthAnimation == width ? 8.5 : 25,
        ),
      ),
    ),
    child: SizedBox(
      width: widthAnimation,
      child: Text(
        btnText,
        textAlign: TextAlign.center,
        style: commonTextStyle(
          size: 16,
          weight: FontWeight.w400,
        ),
      ),
    ),
  );
}
