
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';


// class PrivateMessagePage extends HookConsumerWidget {
//   final String roomId;

//   const PrivateMessagePage(this.roomId, {Key? key})
//       : super(key: key);


//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     List<Widget> allMessages = [
//       const SizedBox(
//         height: 50,
//       ),
//       Padding(
//         padding: const EdgeInsets.all(50),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.white,
//               child:
//                   SvgPicture.asset("assets/icons/profile-icon.svg", width: 50),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Text(
//               'Testing',
//               style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Text(
//               'Meh',
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       )
//     ];
//     List<Widget> messagesWidget = messagesList.when(
//       data: (data) {
//         if (data.isEmpty) {
//           return const [
//             Center(child: Text("Start a conversation with friend!"))
//           ];
//         }
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           // Scroll to the bottom of the ListView after the messages are loaded
//           scrollController.animateTo(
//             scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         });

//         return data
//             .map((e) => MessageWidget(e.senderId == sender.id, [e]))
//             .toList();
//       },
//       error: (error, stackTrace) =>
//           [PageLoadingError(message: error.toString())],
//       loading: () => [const CircularProgressIndicator()],
//     );
//     allMessages.addAll(messagesWidget);
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(receiver.name),
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       ListView(
//                         controller: scrollController,
//                         children: allMessages.map((e) => e).toList(),
//                       ),
//                       latestMessage.getLatestMessage.isNotEmpty ? Positioned(
//                         bottom: 10,
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.width,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               GestureDetector(
//                                 onTap: (){
//                                   scrollController.animateTo(
//                                     scrollController.position.maxScrollExtent,
//                                     duration: const Duration(milliseconds: 150),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                                 child: Card(
//                                   elevation: 8,
//                                   color: Colors.blue,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         Text(latestMessage.getLatestMessage),
//                                         const SizedBox(width: 5,),
//                                         const Icon(Icons.arrow_downward)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ) : const SizedBox(),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 70,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       IconButton(onPressed: () {}, icon: const Icon(Icons.photo)),
//                       IconButton(
//                           onPressed: () {},
//                           icon: const Icon(Icons.camera_alt_rounded)),
//                       Expanded(
//                         child: TextFormField(
//                           controller: messageController,
//                           decoration:
//                               WidgetUtils.messageInputDecoration("Type message here"),
//                         ),
//                       ),
//                       IconButton(
//                           onPressed: () async {
//                             if(messageController.text.isEmpty) return;
//                             FocusScopeNode currentFocus =
//                             FocusScope.of(context);
//                             if (!currentFocus.hasPrimaryFocus) {
//                               currentFocus.unfocus();
//                             }

//                             MessageModel model = MessageModel.name(senderId: sender.id, message: messageController.text, readBy: [], createdAt: DateTime.now());
//                             final send = await messageService.sendMessage(roomId,sender, receiver,model);
//                             if(send){
//                               messageController.clear();
//                             }
//                           }, icon: const Icon(Icons.send)),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Positioned(
//               top: 10,
//               child: Center(
//                 child: Container(
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width,
//                       maxHeight: MediaQuery.of(context).size.height * 0.6,
//                     ),
//                     child: const NotificationWidget()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
