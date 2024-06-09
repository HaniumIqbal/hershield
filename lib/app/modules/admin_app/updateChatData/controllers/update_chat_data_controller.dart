import 'package:get/get.dart';
import 'package:hershield/app/modules/groupchat/controllers/groupchat_controller.dart';
import 'package:hershield/app/modules/groupchat/model/MessageModel.dart';
import 'package:hershield/app/services/UpdateChatService.dart';
import 'package:timeago/timeago.dart' as timeago;

class UpdateChatDataController extends GetxController {
  //TODO: Implement UpdateChatDataController

  UpdateChatRepository updateChatRepository = UpdateChatRepository();
  RxList<MessageModel> messageList = RxList<MessageModel>();
  @override
  void onInit() {
    getAllMessages();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Stream<List<MessageModel>> getAllMessages() {
    updateChatRepository.getAllMessagesStream().listen((event) {
      messageList.value = event;
      print("Get Result Messages");
      print(messageList.length);
    });
    return updateChatRepository.getAllMessagesStream();
  }

  void deleteChat(MessageModel model) {
    updateChatRepository.deleteMessage(model);
  }

  String getParseDate(String date) {
    if (timeago.format(DateTime.parse(date), locale: 'en_short') == "now") {
      return "just now";
    } else {
      return "${timeago.format(DateTime.parse(date), locale: 'en_short')} ago";
    }
  }
}
