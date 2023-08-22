import 'package:flutter/material.dart';

Widget socialButton({
  required VoidCallback onPressed,
  required Widget child,
}) {
  return SizedBox(
    width: 55,
    height: 55,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(55),
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 2),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Container(
        width: 55,
        height: 55,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 5,
          ),
        ),
        child: child,
      ),
    ),
  );
}
