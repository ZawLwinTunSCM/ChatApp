import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:flutter/material.dart';

Widget commonTextField(bool isLogin,
    {required String labelText,
    required TextEditingController controller,
    required ValueNotifier<bool> isObscureText}) {
  final isPassword = labelText == 'Password';
  final isMail = labelText == 'Mail Address';
  return TextFormField(
    style: const TextStyle(color: Colors.white),
    controller: controller,
    obscureText: isObscureText.value && isPassword,
    keyboardType: !isPassword
        ? TextInputType.emailAddress
        : TextInputType.visiblePassword,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$labelText is a required field';
      }
      if (isMail &&
          !RegExp(r'^[\S]+(\.[\S]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
        return 'Invalid $labelText';
      }
      // if (!isLogin &&
      //     isPassword &&
      //     !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>])[A-Za-z\d!@#$%^&*()\-_=+{};:,<.>.]{8,}$')
      //         .hasMatch(value)) {
      //   return 'Invalid $labelText (minimum length : 8 , one capital letter,'
      //       '\none small letter, one number, and one special character)';
      // }
      return null;
    },
    decoration: InputDecoration(
      isDense: true,
      labelText: labelText,
      labelStyle: commonTextStyle(
        size: 15,
        color: AppColor.greyTextColor,
        weight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 17),
      enabledBorder: _commonBorder(false),
      focusedBorder: _commonBorder(true),
      errorBorder: _commonBorder(false),
      focusedErrorBorder: _commonBorder(true),
      prefixIcon: Icon(
        isPassword
            ? Icons.password
            : labelText == 'User Name'
                ? Icons.person
                : Icons.mail,
        color: Colors.white,
      ),
      suffixIcon: isPassword
          ? GestureDetector(
              onTap: () {
                isObscureText.value = !isObscureText.value;
              },
              child: Icon(
                isObscureText.value ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            )
          : null,
    ),
  );
}

OutlineInputBorder _commonBorder(bool focus) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: focus ? Colors.white : AppColor.greyBorderColor,
      width: 0.6,
    ),
  );
}
