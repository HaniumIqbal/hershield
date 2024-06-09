import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hershield/app/modules/groupchat/controllers/groupchat_controller.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/app/modules/groupchat/views/groupchat_view.dart';
import 'package:hershield/constant/colors.dart';

import '../controllers/update_chat_data_controller.dart';

class UpdateChatDataView extends GetView<UpdateChatDataController> {
  const UpdateChatDataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // controller.getAllMessages();
    return Scaffold(
      backgroundColor: MyColor.lightPinkColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Group Chat",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: MyColor.pinkTextColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: controller.getAllMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.all(16.0),
                        itemBuilder: (context, index) {
                          return Align(
                              alignment: Alignment.centerLeft,
                              child: CommentUpdateWidget(
                                commentModel: snapshot.data![index],
                                controller: controller,
                                isAdmin: true,
                              ));
                        }),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text("Loading...");
                } else if (snapshot.data == null) {
                  return const Text("No message found...");
                } else {
                  return const Text("Send your message.");
                }
              },
            ),
          ),
          // MessageInputWidget(controller: controller),
          // const SizedBox(
          //   height: 12,
          // ),
        ],
      ),
    );
  }
}

class CommentUpdateWidget extends StatelessWidget {
  const CommentUpdateWidget({
    super.key,
    required this.commentModel,
    required this.controller,
    this.isAdmin,
  });
  final MessageModel commentModel;
  final UpdateChatDataController controller;

  final bool? isAdmin;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 4, top: 4, left: 6),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.70,
              minWidth: MediaQuery.of(context).size.width * 0.35),
          // width: MediaQuery.of(context).size.width * 0.80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.pinkAccent.withOpacity(0.2),
          ),
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                commentModel.replyTo == ""
                    ? commentModel.senderName!
                    : commentModel.replyTo,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(commentModel.message!, style: const TextStyle(fontSize: 13)),
              const SizedBox(
                height: 3,
              ),
              Text(controller.getParseDate(commentModel.timestamp!),
                  style: const TextStyle(fontSize: 10, color: Colors.black45))
            ],
          ),
        ),
        IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              controller.deleteChat(commentModel);
            },
            icon: const Icon(Icons.delete))
      ],
    );
  }
}
