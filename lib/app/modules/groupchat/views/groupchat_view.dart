import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/constant/colors.dart';

import '../controllers/groupchat_controller.dart';

class GroupchatView extends GetView<GroupchatController> {
  const GroupchatView({Key? key}) : super(key: key);

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
                          var alignment = snapshot.data![index].senderID ==
                                  controller.senderId
                              ? Alignment.centerRight
                              : Alignment.centerLeft;
                          return Align(
                              alignment: alignment,
                              child: CommentWidget(
                                commentModel: snapshot.data![index],
                                controller: controller,
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
          MessageInputWidget(controller: controller),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}

class MessageInputWidget extends StatelessWidget {
  const MessageInputWidget({Key? key, required this.controller})
      : super(key: key);
  final GroupchatController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: MyColor.lightPinkColor,
      child: Row(
        children: [
          Expanded(child: Obx(() {
            return TextField(
              controller: controller.textEditingController.value,
              keyboardType: TextInputType.text,
              cursorColor: MyColor.pinkTextColor,
              maxLines: null,
              focusNode: controller.textFocusNode,
              onChanged: (value) {
                controller.message.value = value;
              },
              decoration: InputDecoration(
                prefixText: controller.senderName.value == ""
                    ? null
                    : "${controller.senderName.value} ",
                focusColor: Colors.purple,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    gapPadding: 0,
                    borderSide: BorderSide(color: MyColor.pinkTextColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100), gapPadding: 0),
                isDense: true,
                fillColor: MyColor.inputFieldColor,
                hintText: "Type your message",
                hintStyle: GoogleFonts.montserrat(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            );
          })),
          Obx(() {
            return IconButton(
                onPressed: () {
                  if (controller.message.value.isNotEmpty) {
                    controller.sendMessage(controller.message.value);
                    controller.textEditingController.value.text = "";
                    controller.message.value = "";
                    controller.senderName.value = "";
                    FocusScope.of(context).unfocus();
                  } else {}
                },
                icon: Icon(
                  Icons.send,
                  color: controller.message.value.isEmpty
                      ? Colors.grey
                      : MyColor.pinkTextColor,
                ));
          })
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.commentModel,
    required this.controller,
  });
  final MessageModel commentModel;
  final GroupchatController controller;
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
                controller.senderId == commentModel.senderID
                    ? commentModel.senderName!
                    : commentModel.replyTo == ""
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
        controller.senderId != commentModel.senderID
            ? IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  controller.senderName.value = commentModel.senderName!;
                  controller.textFocusNode.requestFocus();
                },
                icon: const Icon(Icons.reply))
            : const Text("")
      ],
    );
  }
}
