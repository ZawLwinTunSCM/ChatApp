import 'package:chat/constants/app_color.dart';
import 'package:chat/entities/user.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/providers/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoomPage extends HookConsumerWidget {
  const ChatRoomPage({Key? key, required this.user, required this.chatId})
      : super(key: key);
  final User user;
  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStateNotifier = ref
        .watch(chatStateNotifierProvider.notifier)
        .fetchChatRoom(chatId: chatId);
    final messageController = useTextEditingController();
    final messages = useState<List<String>>([]);
    final message = useState('');

    void sendMessage() {
      messages.value = [...messages.value, messageController.text];
      messageController.clear();
      message.value = '';
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(
                    user.profilePhoto,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  user.name,
                  style: commonTextStyle(size: 15, weight: FontWeight.w500),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
            Row(
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
                  child: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    await launchUrl(Uri.parse('mailto:${user.email}'));
                  },
                  child: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {},
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            )
          ],
        ),
        hasBackButton: true,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColor.darkPurple,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: Text(
                        messages.value[(messages.value.length - 1) - index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.dark,
                        borderRadius: BorderRadius.circular(35.0),
                        border: Border.all(color: AppColor.greyBorderColor),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(
                                Icons.mood,
                                color: AppColor.greyTextColor,
                              ),
                              onPressed: () {}),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              controller: messageController,
                              onChanged: (value) {
                                message.value = messageController.text;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Message",
                                  hintStyle:
                                      TextStyle(color: AppColor.greyTextColor),
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.attach_file,
                                color: AppColor.greyTextColor,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: AppColor.greyTextColor,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        message.value.isEmpty ? Icons.mic : Icons.send,
                        color: AppColor.greyTextColor,
                      ),
                      onPressed: () {
                        message.value.isEmpty ? null : sendMessage();
                      }),
                ],
              ),
            )),
          ]),
        ],
      ),
    );
  }
}
