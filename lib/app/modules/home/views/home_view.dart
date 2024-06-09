import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/background_location.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hershield/app/modules/home/model/EmergencyHubModel.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:hershield/constant/colors.dart';
import 'package:hershield/constant/image_path.dart';
import 'package:hershield/widget/custom_text.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightPinkColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          text: 'Welcome Queens!',
          color: MyColor.pinkTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuotesCarouselSlider(quoteList: controller.quoteList),
            const SizedBox(
              height: 16,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Emergency Hub",
                  color: MyColor.pinkTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 140,
                  child: StreamBuilder<List<EmergencyHubModel>>(
                    stream: controller.getHubData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                // BackgroundLocation.isServiceRunning().then((value) {
                                //
                                //   if(value){
                                //     Firebase.initializeApp().then((value)
                                //     {
                                //       BackgroundLocation.startLocationService(forceAndroidLocationManager: true);
                                //       BackgroundLocation.getLocationUpdates((location) async {
                                //         print("Serves get called");
                                //
                                //
                                //         print("Lat "+location.latitude.toString() + " Lon : "+location.longitude.toString() );
                                //
                                //         // await repository.addUserLiveLocation(model);
                                //
                                //         // if(rideList.length > 0 ){
                                //         //   UserLiveModel model = UserLiveModel(lat: location.latitude.toString(), long: location.longitude.toString());
                                //         //   await repository.addUserLiveLocation(model);
                                //         //   print("Location Updated");
                                //         // }
                                //         // else{
                                //         //   print("List is zero");
                                //         // }
                                //
                                //       });
                                //     });
                                //     // BackgroundLocation.stopLocationService();
                                //   }
                                //   else{
                                //
                                //   }
                                //
                                //   print("Is Running: $value");
                                // });
                                Get.toNamed(
                                    snapshot.data![index].destinationPath,
                                    arguments: [index]);
                              },
                              child: HomeCardWidget(
                                title: snapshot.data![index].title,
                                iconPath: snapshot.data![index].imgPath,
                                index: index,
                              ),
                            );
                          },
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text("Loading...");
                      } else if (snapshot.data == null) {
                        return const Text("No data found...");
                      } else {
                        return const Text("Something went wrong");
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomText(
                  text: "Explore Features",
                  color: MyColor.pinkTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: controller.exploreFeatureModelListInfo.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 2) {
                            controller.onShare(context);
                            controller.getCurrentPosition();
                          } else {
                            Get.toNamed(
                                controller.exploreFeatureModelListInfo[index]
                                    .destinationPath,
                                arguments: [
                                  controller.exploreFeatureModelListInfo[index]
                                      .argTitle,
                                ]);
                          }
                        },
                        child: HomeCardWidget(
                          title: controller
                              .exploreFeatureModelListInfo[index].title,
                          iconPath: controller
                              .exploreFeatureModelListInfo[index].imgPath,
                          index: index,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget({
    super.key,
    required this.title,
    required this.iconPath,
    required this.index,
  });
  final String title, iconPath;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 120,
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: MyColor.cardColor, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: AutoSizeText(
                title,
                minFontSize: 16,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.zillaSlab(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )),
              const SizedBox(
                width: 8,
              ),
              Image.asset(
                iconPath,
                height: index == 2 ? 100 : 120,
                width: index == 2 ? 100 : 120,
                fit: BoxFit.contain,
              )
            ],
          ),
        ));
  }
}

class QuotesCarouselSlider extends StatelessWidget {
  const QuotesCarouselSlider({
    super.key,
    required this.quoteList,
  });
  final List<String> quoteList;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 120.0,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: quoteList.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: MyColor.cardColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: AutoSizeText(
                        item,
                        minFontSize: 18,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.caveat(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Image.asset(
                        girlPower,
                        width: 60,
                        height: 60,
                      )
                    ],
                  ),
                ));
          },
        );
      }).toList(),
    );
  }
}
