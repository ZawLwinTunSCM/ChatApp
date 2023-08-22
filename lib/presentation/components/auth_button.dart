import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.color,
    this.hasSplash = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color color;
  final bool hasSplash;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        backgroundColor: color,
        minimumSize: const Size.fromHeight(48),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(),
        ),
        splashFactory: hasSplash ? null : NoSplash.splashFactory,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
