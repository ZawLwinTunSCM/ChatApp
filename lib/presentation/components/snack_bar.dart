import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String msg) {
  final Widget toastWithButton = Container(
    padding: const EdgeInsets.only(left: 19),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFF333333),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            msg,
            softWrap: true,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const ColoredBox(
          color: Color(0xFF4E4E4E),
          child: SizedBox(
            width: 1,
            height: 23,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 20,
          ),
          color: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ],
    ),
  );
  final snackBar = SnackBar(
    content: toastWithButton,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.zero,
    elevation: 0,
    duration: const Duration(milliseconds: 5000),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
