import 'package:chat/constants/app_color.dart';
import 'package:chat/entities/messages.dart';
import 'package:chat/entities/user.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/snack_bar.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:chat/providers/chats/chats.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatRoomPage extends HookConsumerWidget {
  const ChatRoomPage({Key? key, required this.user, required this.chatId})
      : super(key: key);
  final User user;
  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomMessages = ref
        .watch(chatStateNotifierProvider.notifier)
        .fetchChatRoomMessages(chatId: chatId);
    final messageController = useTextEditingController();
    final hasText = useState(false);
    final sender = ref.watch(currentUserProvider);
    final emoji = ref.watch(emojiProvider);
    void sendMessage() {
      ref.watch(chatStateNotifierProvider.notifier).sendMessages(
          chatId: chatId,
          message: Messages(
              senderId: sender.value!.id,
              text: messageController.text,
              timestamp: DateTime.now()));
      messageController.clear();
    }

    useEffect(() {
      messageController.addListener(() {
        hasText.value = messageController.text.isNotEmpty;
      });
      return null;
    }, [messageController.text]);

    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
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
            child: StreamBuilder(
                stream: chatRoomMessages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No messages yet.'));
                  }
                  final messagesList = snapshot.data ?? [];
                  if (messagesList.isEmpty) {
                    return const SizedBox();
                  }
                  messagesList
                      .sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
                  return ListView.builder(
                    reverse: true,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final msg = messagesList[index];
                      final isSender = msg.senderId == sender.value!.id;
                      return isSender
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: _buildMessageContainer(msg.text,
                                  MediaQuery.of(context).size.width * 0.7),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  radius: 13,
                                  backgroundImage:
                                      NetworkImage(user.profilePhoto),
                                ),
                                _buildMessageContainer(msg.text,
                                    MediaQuery.of(context).size.width * 0.6),
                              ],
                            );
                    },
                  );
                }),
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
                              onPressed: () {
                                ref
                                    .watch(emojiProvider.notifier)
                                    .update((state) => !emoji);
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                          Expanded(
                            child: Focus(
                              onFocusChange: (value) {
                                ref
                                    .watch(emojiProvider.notifier)
                                    .update((state) => value);
                              },
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: messageController,
                                decoration: const InputDecoration(
                                    hintText: "Message",
                                    hintStyle: TextStyle(
                                        color: AppColor.greyTextColor),
                                    border: InputBorder.none),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textInputAction: TextInputAction.newline,
                              ),
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
                        hasText.value ? Icons.send : Icons.mic,
                        color: AppColor.greyTextColor,
                      ),
                      onPressed: () {
                        hasText.value ? sendMessage() : null;
                      }),
                ],
              ),
            )),
          ]),
          Offstage(
              offstage: emoji,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: EmojiPicker(
                  textEditingController: messageController,
                  config: Config(
                    columns: 7,
                    emojiSizeMax: 32 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.30
                            : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: AppColor.darkBlack,
                    iconColor: Colors.grey,
                    enableSkinTones: true,
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    recentsLimit: 30,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.CUPERTINO,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

Container _buildMessageContainer(String text, double maxWidth) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: AppColor.darkPurple,
      borderRadius: BorderRadius.circular(15),
    ),
    constraints: BoxConstraints(
      maxWidth: maxWidth,
    ),
    child: Text(text, style: commonTextStyle(size: 16)),
  );
}
