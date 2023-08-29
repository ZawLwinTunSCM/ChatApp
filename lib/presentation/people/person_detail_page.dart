import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/entities/user.dart';
import 'package:chat/presentation/chats/chat_room.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/setting_button.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:chat/providers/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetailPage extends HookConsumerWidget {
  const PersonDetailPage({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authUserStreamProvider);
    return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'Detail',
            style: commonTextStyle(size: 20),
          ),
          hasBackButton: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 38,
              ),
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(user.profilePhoto),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                user.name,
                style: commonTextStyle(size: 25, weight: FontWeight.w500),
              ),
              Text(
                user.email,
                style: commonTextStyle(size: 20, weight: FontWeight.w300),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      user.phone.isEmpty
                          ? showSnackBar(
                              context,
                              'This user phone number is empty',
                            )
                          : await launchUrl(Uri.parse('tel:${user.phone}'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.greyBorderColor,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          Assets.images.phone,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse('mailto:${user.email}'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.greyBorderColor,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          Assets.images.email,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  GestureDetector(
                    onTap: () async {
                      final chatId =
                          generateChatId('${authUser.value!.uid},${user.id}');
                      final isChatExist = await ref
                          .watch(chatStateNotifierProvider.notifier)
                          .checkChatRoom(chatId: chatId);
                      if (!isChatExist) {
                        ref
                            .watch(chatStateNotifierProvider.notifier)
                            .createChatRoom(chatId: chatId);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChatRoomPage(user: user, chatId: chatId),
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.greyBorderColor,
                          width: 1.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          Assets.images.chatWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.contactShare),
                  text: 'Share Contact'),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.videoCall),
                  text: 'Start Video Call'),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.search),
                  text: 'Search in Conversation'),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.privateChat),
                  text: 'Start Private Conversation'),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.group),
                  text: 'Create Group with ${user.name.split(' ')[0]}'),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.block), text: 'Block'),
              settingButton(
                  icon: SvgPicture.asset(Assets.images.report), text: 'Report'),
            ],
          ),
        ));
  }
}
