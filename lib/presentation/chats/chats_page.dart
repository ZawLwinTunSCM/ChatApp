// ignore_for_file: use_build_context_synchronously

import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/chats/chat_room.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:chat/providers/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatStreamProvider);
    final searchInputController = useTextEditingController();
    final authUser = ref.watch(authUserStreamProvider);
    final searchData = useState('');
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Chats',
          style: commonTextStyle(size: 20),
        ),
      ),
      body: chats.when(
        data: (data) {
          final chatRoom = data.where((element) =>
              element.messages != null &&
              element.chatId.contains(authUser.value!.uid));
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  decoration: BoxDecoration(
                      color: const Color(0xFF343541),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                    child: TextFormField(
                      controller: searchInputController,
                      style: const TextStyle(color: AppColor.greyTextColor),
                      onChanged: (value) {
                        searchData.value = searchInputController.text;
                      },
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColor.greyTextColor,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColor.greyTextColor,
                            ),
                            onPressed: () {
                              searchInputController.clear();
                              searchData.value = '';
                            },
                          ),
                          hintText: 'Search...',
                          hintStyle:
                              const TextStyle(color: AppColor.greyTextColor),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: chatRoom.length,
                    itemBuilder: (context, index) {
                      final chat = chatRoom.toList()[index];
                      final chatParts = chat.chatId.split(authUser.value!.uid);
                      final userIdComma =
                          chatParts[0].isEmpty ? chatParts[1] : chatParts[0];
                      final userIdParts = userIdComma.split(',');
                      final userId = userIdParts[0].isEmpty
                          ? userIdParts[1]
                          : userIdParts[0];
                      final user = ref.watch(userInfoProvider(userId)).value;
                      if (user == null) {
                        return const SizedBox();
                      }
                      return GestureDetector(
                        onTap: () {
                          final chatId = generateChatId(
                              '${authUser.value!.uid},${user.id}');
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ChatRoomPage(user: user, chatId: chatId),
                          ));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              user.profilePhoto,
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: commonTextStyle(
                                size: 16, weight: FontWeight.w500),
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  chat.messages!.last.senderId ==
                                          authUser.value!.uid
                                      ? 'You: ${chat.messages!.last.text}'
                                      : chat.messages!.last.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: commonTextStyle(
                                      size: 13, weight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                DateFormat.jm()
                                    .format(chat.messages!.last.timestamp!),
                                style: commonTextStyle(
                                    size: 13, weight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text("Error: $error"),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
