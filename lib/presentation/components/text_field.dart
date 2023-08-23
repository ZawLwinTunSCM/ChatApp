import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Widget commonTextField(
    {required String labelText,
    required TextEditingController controller,
    ValueNotifier<bool>? isObscureText,
    bool? login,
    bool? readOnly}) {
  final isPassword = labelText == 'Password';
  final isMail = labelText == 'Mail Address';
  final isPhone = labelText == 'Phone';
  final isAddress = labelText == 'Address';
  final hidePassword = isObscureText ?? useState(false);
  final isLogin = login ?? false;
  final isReadOnly = readOnly ?? false;
  return TextFormField(
    readOnly: isReadOnly,
    style: const TextStyle(color: Colors.white),
    controller: controller,
    obscureText: hidePassword.value && isPassword,
    keyboardType: isMail
        ? TextInputType.emailAddress
        : isPhone
            ? TextInputType.phone
            : isAddress
                ? TextInputType.streetAddress
                : TextInputType.text,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$labelText is a required field';
      }
      if (isMail &&
          !RegExp(r'^[\S]+(\.[\S]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
        return 'Invalid $labelText';
      }
      if (!isLogin &&
          isPassword &&
          !RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()\-_=+{};:,<.>])[A-Za-z\d!@#$%^&*()\-_=+{};:,<.>.]{8,}$')
              .hasMatch(value)) {
        return 'Invalid $labelText (minimum length : 8 , one capital letter,'
            '\none small letter, one number, and one special character)';
      }
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
      enabledBorder: _commonBorder(false, isReadOnly),
      focusedBorder: _commonBorder(true, isReadOnly),
      errorBorder: _commonBorder(false, isReadOnly),
      focusedErrorBorder: _commonBorder(true, isReadOnly),
      prefixIcon: Icon(
        isPassword
            ? Icons.password
            : labelText == 'User Name'
                ? Icons.person
                : isPhone
                    ? Icons.phone
                    : isAddress
                        ? Icons.location_city
                        : Icons.mail,
        color: Colors.white,
      ),
      suffixIcon: isPassword
          ? GestureDetector(
              onTap: () {
                hidePassword.value = !hidePassword.value;
              },
              child: Icon(
                hidePassword.value ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            )
          : isMail && isReadOnly
              ? const Icon(
                  Icons.lock,
                  color: Colors.white,
                )
              : null,
    ),
  );
}

OutlineInputBorder _commonBorder(bool focus, bool readOnly) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: focus && !readOnly ? Colors.white : AppColor.greyBorderColor,
      width: 0.6,
    ),
  );
}
