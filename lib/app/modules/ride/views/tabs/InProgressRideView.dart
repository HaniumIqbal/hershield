import 'package:flutter/cupertino.dart';
import 'package:hershield/app/modules/ride/model/AcceptedUserModel.dart';
import 'package:hershield/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hershield/app/modules/ride/model/BookRideModel.dart';
import 'package:hershield/constant/colors.dart';
import 'package:slider_button/slider_button.dart';

import '../../../../../widget/custom_text.dart';

import '../../controllers/ride_controller.dart';

class InProgressRideView extends GetView<RideController> {
  const InProgressRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<BookRideModel>>(
        stream: controller.getAllBookRide(),
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
                  padding: const EdgeInsets.all(4.0),
                  itemBuilder: (context, index) {
                    DateTime currentDate = DateTime.now();
                    var rideDate = DateTime.parse(snapshot.data![index].time);
                    bool isDatePassed = false;
                    bool orderAccepted = false;
                    snapshot.data![index].acceptedUserList!.forEach((element) {
                      print(
                          "You accepted this order${element.id}");
                      if (element.id.isNotEmpty &&
                          element.id == controller.userID) {
                        orderAccepted = true;
                        controller.orderMessage.value =
                            "You accepted this ride";
                        print(
                            "You accepted this order${snapshot.data![index].capacity}");
                      }
                    });


                    if (rideDate.isBefore(currentDate)) {
                      isDatePassed = true;
                      controller.orderMessage.value =
                          "The ride has been started";
                    } else {
                      isDatePassed = false;
                    }

                    var isSameUser =
                        snapshot.data![index].userID == controller.userID
                            ? true
                            : false;
                    if(isSameUser){
                      controller.orderMessage.value =
                      "You booked this ride";
                    }
                    return InprogressBookRideWidget(
                        model: snapshot.data![index],
                        isSameUser: isSameUser,
                        isDatePassed: isDatePassed,
                        controller: controller,
                        message: controller.orderMessage.value,
                      isAcceptRide: orderAccepted, arg: index,
                    );
                  }),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."));
          } else if (snapshot.data == null) {
            return const Center(child: Text("No ride found..."));
          } else {
            return const Center(child: Text("No ride found."));
          }
        },
      ),
    );
  }
}

class InprogressBookRideWidget extends StatelessWidget {
  const InprogressBookRideWidget({
    super.key,
    required this.model,
    required this.isSameUser,
    required this.isDatePassed,
    required this.controller,
    required this.message,
    required this.isAcceptRide, required this.arg,
  });

  final BookRideModel model;
  final bool isSameUser;
  final bool isDatePassed;
  final bool isAcceptRide;
  final RideController controller;
  final String message;
  final int arg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                spreadRadius: 0.2,
                offset: Offset(0, 0))
          ]),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: model.userName,
                color: MyColor.pinkTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              const CustomText(
                text: "  wants to share ride with you.",
                color: Colors.black45,
                fontSize: 12,
              ),
              Spacer(),
              InkWell(
                highlightColor: Colors.black,
                onTap: (){
                  controller.launchWhatsAppUrl(model.phoneNo.toString());
                  print("object");
                },
                child:
                Padding(
                  padding: EdgeInsets.all(2),
                  child: Image.asset("assets/images/whatsapp.png",height: 20,),) ,
                )
                



            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width * 0.42,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: MyColor.lightPinkColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2,
                              spreadRadius: 0.1,
                              offset: Offset(0, 0))
                        ]),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              "PKR ${double.parse(model.totalFare).roundToDouble()} ",
                          color: MyColor.pinkTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        Image.asset(
                          "assets/images/rm.png",
                          height: 40,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "Capacity",
                                  color: MyColor.pinkTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                const Spacer(),
                                CustomText(
                                  text: model.capacity.toString(),
                                  color: MyColor.pinkTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                CustomText(
                                  text: "Your's Fare",
                                  color: MyColor.pinkTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                                const Spacer(),
                                CustomText(
                                  text: model.yourfare,
                                  color: MyColor.pinkTextColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/images/map_direction.png"),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 2,
                              spreadRadius: 0.1,
                              offset: Offset(0, 0))
                        ]),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Get.toNamed(Routes.USER_LIVE_MAP,arguments: arg);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    color: MyColor.pinkTextColor),
                                borderRadius: BorderRadius.circular(100),
                                color: MyColor.lightPinkColor),
                            child: CustomText(
                              text:
                                  "${double.parse(model.totalDistance).roundToDouble()} Km",
                              color: MyColor.pinkTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 4,
                      spreadRadius: 0.2,
                      offset: Offset(0, 0))
                ]),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.my_location_outlined,
                            color: Colors.red,
                            size: 12,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              width: 2,
                              color: Colors.black,
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.red,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    "Pick up ( ${DateFormat.yMd().add_jm().format(DateTime.parse(model.time))} )",
                                color: MyColor.pinkTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                maxLine: 1,
                                text: model.fromPlace,
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Drop off",
                                color: MyColor.pinkTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomText(
                                maxLine: 1,
                                text: model.toPlace,
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(

            height:  12 ,
          ),
          isSameUser? _orderStarted(message):
          isDatePassed
              ? _orderStarted(message)
              : model.capacity == 0 && isAcceptRide
                  ? _orderStarted("Accepted, No capacity left") :
              isAcceptRide ? _orderStarted(message)
                  : Center(
                      child: SliderButton(
                      height: 60,
                      radius: 100,
                      vibrationFlag: true,
                      buttonColor: Colors.green,
                      backgroundColor: MyColor.pinkTextColor,
                      highlightedColor: Colors.green,
                      baseColor: Colors.white,
                      action: () async {
                        int capacity = model.capacity - 1;
                        model.capacity = capacity;
                        AcceptedUserModel userModel =
                            AcceptedUserModel(id: controller.userID);
                        model.acceptedUserList!.add(userModel);
                        controller.updateRideInFirebase(model);
                        return true;
                      },
                      label: const Center(
                        child: CustomText(
                            text: "Slide to accept ride", color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_outlined,
                        size: 18,
                      ),
                    ))
        ],
      ),
    );
  }


  Widget _orderStarted(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColor.lightPinkColor),
      child: Center(
          child: CustomText(
        text: msg,
        color: CupertinoColors.inactiveGray,
        fontSize: 14,
      )),
    );
  }
}

// class _orderStarted extends StatelessWidget {
//   const _orderStarted({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: MyColor.lightPinkColor),
//      child: CustomText(text: "This ride has been started!",color: CupertinoColors.inactiveGray, fontSize: 14, ),
//     );
//   }
// }
