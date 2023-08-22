import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authUser = ref.watch(authUserStreamProvider).asData!.value;
    // final alertUser = ref.watch(userAlertProvider(authUser!.uid));
    // if ((authUser.metadata.creationTime!.toLocal().toString().split('.')[0] ==
    //         authUser.metadata.lastSignInTime!
    //             .toLocal()
    //             .toLocal()
    //             .toString()
    //             .split('.')[0]) &&
    //     alertUser.asData!.value) {
    //   Timer(const Duration(seconds: 1), () {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           insetPadding: EdgeInsets.only(
    //               bottom: MediaQuery.of(context).size.height * 0.7),
    //           backgroundColor: AppColor.darkPurple,
    //           content:
    //               const Text('Complete your profile for better experience.'),
    //           actions: [
    //             TextButton(
    //               onPressed: () async {
    //                 Navigator.of(context).pop();
    //                 SharedPreferences prefs =
    //                     await SharedPreferences.getInstance();
    //                 await prefs.setBool('userAlert_${authUser.uid}', false);
    //                 ref.refresh(userAlertProvider(authUser.uid));
    //               },
    //               child: const Icon(Icons.arrow_forward),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   });
    // }

    return const Scaffold(
      body: Center(
        child: Text("Chat Page"),
      ),
    );
  }
}
