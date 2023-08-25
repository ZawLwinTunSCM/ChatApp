import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:chat/providers/chats/chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatStreamProvider);
    final authUser = ref.watch(authUserProvider);
    final searchInputController = useTextEditingController();
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
          data;
          print(data.first.messages);
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
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final chat = data.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              authUser!.photoURL!,
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(
                              //   builder: (context) =>
                              //       PersonDetailPage(user: user),
                              // ));
                            },
                            child: Text(
                              authUser.displayName!,
                              style: commonTextStyle(
                                  size: 16, weight: FontWeight.w500),
                            ),
                          ),
                          trailing: GestureDetector(
                            child: SvgPicture.asset(Assets.images.chat),
                            onTap: () {
                              //   ref
                              //       .watch(
                              //           chatStateNotifierProvider.notifier)
                              //       .createChatRoom(
                              //           senderId: authUser!.uid,
                              //           receiverId: user.id);
                              //   Navigator.of(context)
                              //       .push(MaterialPageRoute(
                              //     builder: (context) => ChatRoomPage(
                              //         user: user,
                              //         chatId: '${authUser.uid},${user.id}'),
                              //   ));
                            },
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
