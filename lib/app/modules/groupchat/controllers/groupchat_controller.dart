import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/groupchat/bindings/groupchat_binding.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/app/modules/profile/bindings/profile_binding.dart';
import 'package:hershield/app/modules/profile/controllers/profile_controller.dart';
import 'package:hershield/app/services/ChatService.dart';
import 'package:hershield/app/services/UpdateChatService.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupchatController extends GetxController {
  late ProfileController profileController;
  ChatRepository chatRepository = ChatRepository();
  final senderId = FirebaseAuth.instance.currentUser!.uid;
  final FocusNode textFocusNode = FocusNode();
  Rx<TextEditingController> textEditingController = TextEditingController().obs;
  RxString message = "".obs;
  RxList<MessageModel> messageList = RxList<MessageModel>();
  RxString senderName = "".obs;
  String replyTo = "";
  final count = 0.obs;
  @override
  void onInit() {
    ProfileBinding();
    chatRepository = ChatRepository();
    profileController = Get.put(ProfileController());
    getAllMessages();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    textEditingController.value.dispose();
    textFocusNode.dispose();
    super.onClose();
  }

  void sendMessage(String message) {
    if (senderName.value.isNotEmpty) {
      replyTo =
          "${profileController.userInformation.fName!} to ${senderName.value}";
    } else {
      replyTo = "";
    }
    MessageModel messageModel = MessageModel(
        message: message,
        senderID: senderId,
        replyTo: replyTo,
        senderName: profileController.userInformation.fName!,
        timestamp: DateTime.now().toString());
    if (messageModel != null) {
      print(messageModel.toJson());
      chatRepository.sendMessage(messageModel);
    }
  }

  /// GET ALL MESSAGES
  Stream<List<MessageModel>> getAllMessages() {
    chatRepository.getAllMessagesStream().listen((event) {
      messageList.value = event;
      print("Get Result Messages");
      print(messageList.length);
    });
    return chatRepository.getAllMessagesStream();
  }

  /// PARCING DATE
  String getParseDate(String date) {
    if (timeago.format(DateTime.parse(date), locale: 'en_short') == "now") {
      return "just now";
    } else {
      return "${timeago.format(DateTime.parse(date), locale: 'en_short')} ago";
    }
  }
}
