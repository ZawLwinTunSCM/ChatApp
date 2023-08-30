import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/chats/chats_page.dart';
import 'package:chat/presentation/people/people_page.dart';
import 'package:chat/presentation/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends HookConsumerWidget {
  HomePage({super.key});

  final List<Widget> widgets = [
    const ChatPage(),
    const PeoplePage(),
    const ProfilePage()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    return Scaffold(
      body: widgets[currentIndex.value],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex.value,
        onTap: (i) => currentIndex.value = i,
        items: [
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              Assets.images.chats,
            ),
            title: const Text("Chats"),
            selectedColor: AppColor.lightBlue,
          ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              Assets.images.people,
            ),
            title: const Text("People"),
            selectedColor: AppColor.lightBlue,
          ),
          SalomonBottomBarItem(
            icon: SvgPicture.asset(
              Assets.images.profile,
            ),
            title: const Text("Profile"),
            selectedColor: AppColor.lightBlue,
          ),
        ],
      ),
    );
  }
}
