import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/widget/custom_text.dart';
import '../controllers/police_help_line_controller.dart';

class PoliceHelpLineView extends GetView<PoliceHelpLineController> {
  PoliceHelpLineView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.lightPinkColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: StreamBuilder<List<EmergencyHubModel>>(
          stream: controller.homeController.getHubData(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              final list = snapshot.data![controller.index].argument;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: snapshot.data![controller.index].title,
                      color: MyColor.pinkTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    Column(
                      children: List.generate(
                        list.length,
                        (index) => ListTile(
                          minVerticalPadding: 15,
                          contentPadding: const EdgeInsets.all(0),
                          horizontalTitleGap: 0,
                          leading: SvgPicture.asset(
                            list[index].iconData,
                          ),
                          title: CustomText(
                            text: list[index].title,
                            color: MyColor.pinkTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: CustomText(
                            text: list[index].subTtile,
                            color: Colors.black87,
                            maxLine: 2,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (list.firstOrNull != null) {
                          if (snapshot.data![controller.index].title
                              .contains("Police")) {
                            controller.launchMapUrl(
                                list.first.mapLink!, "police station near me");
                          } else if (snapshot.data![controller.index].title
                              .contains("Ambulance")) {
                            controller.launchMapUrl(
                                list.first.mapLink!, "hospital near me");
                          } else {
                            controller.launchMapUrl(list.first.mapLink!, "");
                          }
                        }
                      },
                      child: Image.asset(mapPath),
                    )
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else if (snapshot.data == null) {
              return const Text("No data found...");
            } else {
              return const Text("Something went wrong");
            }
          },
        ));
  }
}
