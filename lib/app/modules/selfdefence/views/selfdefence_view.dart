import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/constant/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../constant/colors.dart';
import '../controllers/selfdefence_controller.dart';

class SelfdefenceView extends GetView<SelfdefenceController> {
  const SelfdefenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightPinkColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Self Defence",
          style: TextStyle(color: MyColor.pinkTextColor),
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
      body: ListView.builder(
          itemCount: controller.selfDefenseItemList.length,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(12),
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: MyColor.inputFieldColor,
                image: DecorationImage(
                    image: AssetImage(
                        controller.selfDefenseItemList[index].imgPath),
                    fit: BoxFit.fill),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.black.withOpacity(0.7)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(5)),
                        ),
                        onPressed: () {
                          Get.to(() => WebViewScreen(
                                url: controller
                                    .selfDefenseItemList[index].youtubeLink,
                                controller: controller,
                              ));
                        },
                        child: Row(
                          children: [
                            Icon(
                              index == 3
                                  ? Icons.shopping_cart
                                  : Icons.ondemand_video,
                              color: Colors.red,
                              size: 18,
                            ),
                            Text(
                              controller.selfDefenseItemList[index].shopLink,
                              style: const TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  WebViewScreen({required this.url, required this.controller});

  SelfdefenceController controller;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightPinkColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Self Defence",
          style: TextStyle(color: MyColor.pinkTextColor),
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
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),
            onLoadStop: (webController, uri) {
              controller.isLoading.value = false;
            },
          ),
          Obx(() {
            return Center(
              child: controller.isLoading.value
                  ? CircularProgressIndicator()
                  : Text(""),
            );
          })
        ],
      ),
    );
  }
}
