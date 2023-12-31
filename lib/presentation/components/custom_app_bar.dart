import 'package:chat/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.hasBackButton = false,
      this.title,
      this.centerTitle = true});
  final Widget? title;
  final bool hasBackButton;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColor.dark,
      titleSpacing: 0,
      leading: hasBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : const SizedBox(),
      elevation: 0,
      title: title,
      centerTitle: centerTitle,
    );
  }
}
