// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/constant/collection_name.dart';
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/constant/show_toast_dialog.dart';
import 'package:mekinaparking/controller/booking_controller.dart';
import 'package:mekinaparking/model/order_model.dart';
import 'package:mekinaparking/themes/app_them_data.dart';
import 'package:mekinaparking/themes/common_ui.dart';
import 'package:mekinaparking/themes/responsive.dart';
import 'package:mekinaparking/themes/round_button_fill.dart';
import 'package:mekinaparking/ui/booking_process/review_summery_screen.dart';
import 'package:mekinaparking/ui/my_booking/parking_ticket_screen.dart';
import 'package:mekinaparking/utils/dark_theme_provider.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';
import 'package:mekinaparking/utils/network_image_widget.dart';
import 'package:provider/provider.dart';

class MyBookingScreen extends StatelessWidget {
  final bool isBack;

  const MyBookingScreen({required this.isBack, super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: UiInterface()
          .customAppBar(context, themeChange, isBack: isBack, 'My Booking'.tr),
      body: GetX<BookingController>(
          init: BookingController(),
          builder: (controller) {
            return controller.isLoading.value
                ? Constant.loader()
                : DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: themeChange.getThem()
                              ? AppThemData.grey10
                              : AppThemData.white,
                          child: TabBar(
                            onTap: (value) {
                              controller.selectedTabIndex.value = value;
                            },
                            labelStyle: const TextStyle(
                                fontFamily: AppThemData.semiBold),
                            labelColor: themeChange.getThem()
                                ? AppThemData.primary07
                                : AppThemData.grey10,
                            unselectedLabelStyle:
                                const TextStyle(fontFamily: AppThemData.medium),
                            unselectedLabelColor: themeChange.getThem()
                                ? AppThemData.grey06
                                : AppThemData.grey06,
                            indicatorColor: AppThemData.primary06,
                            indicatorWeight: 1,
                            tabs: [
                              Tab(
                                text: "ongoing".tr,
                              ),
                              Tab(
                                text: "completed".tr,
                              ),
                              Tab(
                                text: "canceled".tr,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              onGoingView(themeChange),
                              completedView(themeChange),
                              canceledView(themeChange),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
          }),
    );
  }

  Widget onGoingView(themeChange) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(CollectionName.bookedParkingOrder)
          .where("userId", isEqualTo: FireStoreUtils.getCurrentUid())
          .where('status', whereIn: [Constant.placed, Constant.onGoing])
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'.tr));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Constant.loader();
        }
        return snapshot.data!.docs.isEmpty
            ? Constant.showEmptyView(message: "No Book Parking Found".tr)
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  OrderModel orderModel = OrderModel.fromJson(
                      snapshot.data!.docs[index].data()
                          as Map<String, dynamic>);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeChange.getThem()
                            ? AppThemData.grey10
                            : AppThemData.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: NetworkImageWidget(
                                      imageUrl: orderModel.parkingDetails!.image
                                          .toString(),
                                      height: Responsive.height(9, context),
                                      width: Responsive.height(9, context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderModel.parkingDetails!.name
                                              .toString(),
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemData.grey01
                                                : AppThemData.grey10,
                                            fontSize: 14,
                                            fontFamily: AppThemData.semiBold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          orderModel.parkingDetails!.address
                                              .toString(),
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: AppThemData.grey07,
                                              fontSize: 12,
                                              fontFamily: AppThemData.regular,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icon/ic_parking_p.svg",
                                              color: AppThemData.blueLight07,
                                              width: 18,
                                              height: 18,
                                            ),
                                            Text(
                                              "Parking Slot : ${orderModel.parkingSlotId.toString()}"
                                                  .tr,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color:
                                                      AppThemData.blueLight07,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemData.medium,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RoundedButtonFill(
                                    title: "Summary".tr,
                                    height: 5,
                                    color: AppThemData.primary06,
                                    onPress: () {
                                      Get.to(() => const ReviewSummaryScreen(),
                                          arguments: {
                                            "orderModel": orderModel
                                          });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: RoundedButtonFill(
                                    title: "View Ticket".tr,
                                    color: themeChange.getThem()
                                        ? AppThemData.grey09
                                        : AppThemData.grey03,
                                    textColor: themeChange.getThem()
                                        ? AppThemData.grey03
                                        : AppThemData.grey09,
                                    height: 5,
                                    onPress: () {
                                      Get.to(() => const ParkingTicketScreen(),
                                          arguments: {
                                            "orderModel": orderModel
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            orderModel.status == Constant.placed ||
                                    orderModel.status == Constant.completed ||
                                    orderModel.status == Constant.onGoing
                                ? const SizedBox(
                                    height: 12,
                                  )
                                : SizedBox.shrink(),
                            orderModel.status == Constant.placed ||
                                    orderModel.status == Constant.completed ||
                                    orderModel.status == Constant.onGoing
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: RoundedButtonFill(
                                          title: "Add Extra Time".tr,
                                          color: AppThemData.primary06,
                                          textColor: Colors.white,
                                          height: 5,
                                          onPress: () async {
                                            await showPhoneNumberDialog(
                                                context, orderModel);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
      },
    );
  }

  Future<void> showPhoneNumberDialog(
      BuildContext context, OrderModel orderModel) async {
    final TextEditingController extraTimeHoursController =
        TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter Extra Time Hours',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: extraTimeHoursController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Hours',
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppThemData.primary06,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppThemData.primary06,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: () async {
                String extraTime = extraTimeHoursController.text.toString();
                if (extraTime.isNotEmpty) {
                  ShowToastDialog.showLoader("Please wait".tr);
                  orderModel.isExtraTimeApplied = true;
                  orderModel.extraTimeHours = extraTime.toString();
                  int extraTimeInHours = int.tryParse(extraTime) ?? 0;
                  Timestamp extraTimeStart = orderModel.bookingEndTime!;
                  Timestamp extraTimeEnd = Timestamp.fromDate(
                    extraTimeStart
                        .toDate()
                        .add(Duration(hours: extraTimeInHours)),
                  );
                  orderModel.extraTimeStart = extraTimeStart;
                  orderModel.extraTimeEnd = extraTimeEnd;
                  await FireStoreUtils.setOrder(orderModel).then((value) {
                    ShowToastDialog.closeLoader();
                  });
                  Get.back();
                  ShowToastDialog.showToast("Extra Time Applied");
                } else {
                  ShowToastDialog.showToast("Please enter extra time");
                }
              },
              child: Text(' Save '),
            ),
          ],
        );
      },
    );
  }

  Widget completedView(themeChange) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(CollectionName.bookedParkingOrder)
          .where("userId", isEqualTo: FireStoreUtils.getCurrentUid())
          .where('status', whereIn: [Constant.completed])
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'.tr));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Constant.loader();
        }
        return snapshot.data!.docs.isEmpty
            ? Constant.showEmptyView(message: "No Completed Booking Found")
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  OrderModel orderModel = OrderModel.fromJson(
                      snapshot.data!.docs[index].data()
                          as Map<String, dynamic>);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeChange.getThem()
                            ? AppThemData.grey10
                            : AppThemData.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: NetworkImageWidget(
                                      imageUrl: orderModel.parkingDetails!.image
                                          .toString(),
                                      height: Responsive.height(9, context),
                                      width: Responsive.height(9, context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderModel.parkingDetails!.name
                                              .toString(),
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemData.grey01
                                                : AppThemData.grey10,
                                            fontSize: 14,
                                            fontFamily: AppThemData.semiBold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          orderModel.parkingDetails!.address.toString(),
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: AppThemData.grey07,
                                              fontSize: 12,
                                              fontFamily: AppThemData.regular,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RoundedButtonFill(
                                    title: "Summary".tr,
                                    height: 5,
                                    color: AppThemData.primary06,
                                    onPress: () {
                                      Get.to(() => const ReviewSummaryScreen(),
                                          arguments: {
                                            "orderModel": orderModel
                                          });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
      },
    );
  }

  Widget canceledView(themeChange) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(CollectionName.bookedParkingOrder)
          .where("userId", isEqualTo: FireStoreUtils.getCurrentUid())
          .where('status', whereIn: [Constant.canceled])
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'.tr));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Constant.loader();
        }
        return snapshot.data!.docs.isEmpty
            ? Constant.showEmptyView(message: "No Canceled Booking Found")
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  OrderModel orderModel = OrderModel.fromJson(
                      snapshot.data!.docs[index].data()
                          as Map<String, dynamic>);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeChange.getThem()
                            ? AppThemData.grey10
                            : AppThemData.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: NetworkImageWidget(
                                      imageUrl: orderModel.parkingDetails!.image
                                          .toString(),
                                      height: Responsive.height(9, context),
                                      width: Responsive.height(9, context),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderModel.parkingDetails!.name
                                              .toString(),
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemData.grey01
                                                : AppThemData.grey10,
                                            fontSize: 14,
                                            fontFamily: AppThemData.semiBold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          orderModel.parkingDetails!.address
                                              .toString(),
                                          maxLines: 2,
                                          style: const TextStyle(
                                              color: AppThemData.grey07,
                                              fontSize: 12,
                                              fontFamily: AppThemData.regular,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
      },
    );
  }
}
