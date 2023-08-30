import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Widget commonTextField(
    {required String labelText,
    required TextEditingController controller,
    ValueNotifier<bool>? isObscureText,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool? readOnly,
    String? Function(String?)? validator}) {
  final hidePassword = isObscureText ?? useState(false);
  final isReadOnly = readOnly ?? false;
  return TextFormField(
    readOnly: isReadOnly,
    style: const TextStyle(color: Colors.white),
    controller: controller,
    obscureText: hidePassword.value,
    keyboardType: keyboardType ?? TextInputType.text,
    validator: validator,
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
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
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
