import 'package:chat/assets/assets.gen.dart';
import 'package:chat/constants/app_color.dart';
import 'package:chat/constants/url.dart';
import 'package:chat/presentation/components/common.dart';
import 'package:chat/presentation/components/custom_app_bar.dart';
import 'package:chat/presentation/components/image_preview.dart';
import 'package:chat/presentation/people/person_detail_page.dart';
import 'package:chat/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chat/providers/people/people.dart';

class PeoplePage extends HookConsumerWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(peopleStreamProvider);
    final authUser = ref.watch(authUserProvider);
    final searchInputController = useTextEditingController();
    final searchData = useState('');
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'People',
          style: commonTextStyle(size: 20),
        ),
      ),
      body: users.when(
        data: (data) {
          data.where(
            (user) {
              return user.id != authUser!.uid;
            },
          );
          final filteredUsers = searchData.value.trim().isEmpty
              ? data
              : data.where(
                  (user) {
                    return user.name
                        .toLowerCase()
                        .contains(searchData.value.toLowerCase().trim());
                  },
                );
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
                  child: filteredUsers.isEmpty
                      ? Text(
                          'No User Found....',
                          style: commonTextStyle(
                              size: 13, weight: FontWeight.w500),
                        )
                      : ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers.toList()[index];
                            final img = user.profilePhoto.isEmpty
                                ? defaultProfile
                                : user.profilePhoto;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () {
                                    showFullScreenImage(context, img);
                                  },
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      img,
                                    ),
                                  ),
                                ),
                                title: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          PersonDetailPage(user: user),
                                    ));
                                  },
                                  child: Text(
                                    user.name,
                                    style: commonTextStyle(
                                        size: 16, weight: FontWeight.w500),
                                  ),
                                ),
                                trailing: GestureDetector(
                                    child:
                                        SvgPicture.asset(Assets.images.chat)),
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
