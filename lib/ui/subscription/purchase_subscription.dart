import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/controller/purchase_subscription_controller.dart';
import 'package:mekinaparking/model/subscription_model.dart';
import 'package:mekinaparking/themes/app_them_data.dart';
import 'package:mekinaparking/themes/common_ui.dart';
import 'package:mekinaparking/themes/round_button_fill.dart';
import 'package:mekinaparking/ui/subscription/subscription_payment_select_screen.dart';
import 'package:mekinaparking/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class PurchaseSubscriptionScreen extends StatelessWidget {
  const PurchaseSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PurchaseSubscriptionController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface().customAppBar(
              context,
              themeChange,
              'Purchase Subscription'.tr,
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.subscription.isEmpty
                    ? Constant.showEmptyView(
                        message: "No subscription added".tr)
                    : Column(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return ListView.separated(
                                itemCount: controller.subscription.length,
                                padding: EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  SubscriptionModel subscription =
                                      controller.subscription[index];
                                  final parking = controller
                                      .parkingMap[subscription.parkingId];
                                  final parkingName = parking?.name ?? '';
                                  return Card(
                                    color: themeChange.getThem()
                                        ? AppThemData.grey10
                                        : AppThemData.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subscription.title.toString(),
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemData.grey01
                                                  : AppThemData.grey10,
                                              fontSize: 14,
                                              fontFamily: AppThemData.semiBold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "ID : ",
                                                style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemData.grey01
                                                        : AppThemData.grey07,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        AppThemData.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Text(
                                                subscription.id.toString(),
                                                style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemData.grey01
                                                        : AppThemData.grey07,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        AppThemData.regular,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Parking ID : ",
                                                style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemData.grey01
                                                        : AppThemData.grey07,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        AppThemData.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  subscription.parkingId
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemData.grey01
                                                          : AppThemData.grey07,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          AppThemData.regular,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Parking Name : ",
                                                style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemData.grey01
                                                        : AppThemData.grey07,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        AppThemData.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  parkingName.toString(),
                                                  style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemData.grey01
                                                          : AppThemData.grey07,
                                                      fontSize: 12,
                                                      fontFamily:
                                                          AppThemData.regular,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Max Space: ${subscription.maxSpace.toString()}"
                                                    .tr,
                                                style: const TextStyle(
                                                  color:
                                                      AppThemData.blueLight07,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemData.semiBold,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: 18,
                                                  child: VerticalDivider(
                                                      thickness: 1,
                                                      color:
                                                          AppThemData.grey05)),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: subscription
                                                              .isEnable ==
                                                          true
                                                      ? AppThemData.success07
                                                      : AppThemData.error07,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                ),
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                    child: Text(
                                                      subscription.isEnable ==
                                                              true
                                                          ? "Active".tr
                                                          : "Disable".tr,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppThemData.white,
                                                          fontFamily:
                                                              AppThemData
                                                                  .medium),
                                                    )),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          SizedBox(
                                            height: 60,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  subscription.plan!.length,
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(width: 8),
                                              itemBuilder:
                                                  (context, planIndex) {
                                                Plan plan = subscription
                                                    .plan![planIndex];
                                                return Obx(() {
                                                  bool isSelected = controller
                                                              .selectedSubscriptionId
                                                              .value ==
                                                          subscription.id &&
                                                      controller
                                                              .selectedPlanIndex
                                                              .value ==
                                                          planIndex;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      controller.selectPlan(
                                                          subscription.id!,
                                                          planIndex);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? AppThemData
                                                                .primary06
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: AppThemData
                                                                .primary06),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "${plan.months} Months",
                                                                  style: TextStyle(
                                                                      color: isSelected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black)),
                                                              Text(
                                                                  "Br${plan.price}",
                                                                  style: TextStyle(
                                                                      color: isSelected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black)),
                                                            ],
                                                          ),
                                                          SizedBox(width: 8),
                                                          Radio<int>(
                                                            value: planIndex,
                                                            groupValue: controller
                                                                        .selectedSubscriptionId
                                                                        .value ==
                                                                    subscription
                                                                        .id
                                                                ? controller
                                                                    .selectedPlanIndex
                                                                    .value
                                                                : -1,
                                                            onChanged:
                                                                (int? value) {
                                                              if (value !=
                                                                  null) {
                                                                controller
                                                                    .selectPlan(
                                                                        subscription
                                                                            .id!,
                                                                        value);
                                                              }
                                                              controller
                                                                  .selectedPlanPrice
                                                                  .value = plan
                                                                      .price ??
                                                                  "";
                                                              controller
                                                                  .selectedPlanMonths
                                                                  .value = plan
                                                                      .months ??
                                                                  "";
                                                              controller
                                                                      .subscriptionId
                                                                      .value =
                                                                  subscription
                                                                          .id ??
                                                                      "";
                                                              ;
                                                              controller
                                                                      .selectedPlanId
                                                                      .value =
                                                                  subscription
                                                                          .id ??
                                                                      "";
                                                              controller
                                                                  .selectedMaxSpace
                                                                  .value = subscription
                                                                      .maxSpace ??
                                                                  "";
                                                              controller
                                                                  .selectedOwnerId
                                                                  .value = subscription
                                                                      .ownerId ??
                                                                  "";
                                                              controller
                                                                  .selectedParkingId
                                                                  .value = subscription
                                                                      .parkingId ??
                                                                  "";
                                                              controller
                                                                  .selectedTitle
                                                                  .value = subscription
                                                                      .title ??
                                                                  "";
                                                              controller
                                                                  .update();
                                                            },
                                                            activeColor:
                                                                AppThemData
                                                                    .white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 12,
                                  );
                                },
                              );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10.0, left: 10.0, right: 10.0),
                            child: RoundedButtonFill(
                              title: "Continue".tr,
                              height: 5.5,
                              color: AppThemData.primary06,
                              fontSizes: 16,
                              onPress: () {
                                Get.to(() => SubscriptionPaymentSelectScreen(),
                                    arguments: {
                                      'subscriptionId':
                                          controller.subscriptionId.value,
                                      'price':
                                          controller.selectedPlanPrice.value,
                                      'months':
                                          controller.selectedPlanMonths.value,
                                      'id': controller.selectedPlanId.value,
                                      'maxSpace':
                                          controller.selectedMaxSpace.value,
                                      'ownerId':
                                          controller.selectedOwnerId.value,
                                      'parkingId':
                                          controller.selectedParkingId.value,
                                      'title': controller.selectedTitle.value
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
          );
        });
  }
}
