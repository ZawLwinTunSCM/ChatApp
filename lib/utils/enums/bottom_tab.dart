import 'package:chat/presentation/chats/chats_page.dart';
import 'package:chat/presentation/people/people_page.dart';
import 'package:chat/presentation/profile/profile_page.dart';
import 'package:flutter/material.dart';

import '../../assets/assets.gen.dart';

enum TabItem {
  chats(labelText: 'Chats'),
  people(labelText: 'People'),
  profile(labelText: 'Profile');

  const TabItem({
    required this.labelText,
  });

  @override
  String toString() => name;

  final String labelText;
}

extension TabItemEx on TabItem {
  /// ページのビルダー
  WidgetBuilder pageBuilder(BuildContext context) {
    switch (this) {
      case TabItem.chats:
        return (context) => const ChatPage();
      case TabItem.people:
        return (context) => const PeoplePage();
      case TabItem.profile:
        return (context) => const ProfilePage();
    }
  }

  /// タブに表示する画像のパス
  String imagePath() {
    switch (this) {
      case TabItem.chats:
        return Assets.images.logoSvg;
      case TabItem.people:
        return Assets.images.logoSvg;
      case TabItem.profile:
        return Assets.images.logoSvg;
    }
  }

  /// 選択された時にタブに表示する画像のパス
  String selectedImagePath() {
    switch (this) {
      case TabItem.chats:
        return Assets.images.logoSvg;
      case TabItem.people:
        return Assets.images.logoSvg;
      case TabItem.profile:
        return Assets.images.logoSvg;
    }
  }

  /// 画像のサイズを揃える
  double imageSize() {
    switch (this) {
      case TabItem.chats:
        return 27;
      case TabItem.people:
        return 27;
      case TabItem.profile:
        return 27;
    }
  }
}
