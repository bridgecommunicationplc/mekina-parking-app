import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/controller/profile_controller.dart';
import 'package:mekinaparking/model/subscription_model.dart';
import 'package:mekinaparking/model/user_model.dart';
import 'package:mekinaparking/themes/app_them_data.dart';
import 'package:mekinaparking/themes/common_ui.dart';
import 'package:mekinaparking/themes/custom_dialog_box.dart';
import 'package:mekinaparking/themes/responsive.dart';
import 'package:mekinaparking/themes/round_button_fill.dart';
import 'package:mekinaparking/ui/auth_screen/login_screen.dart';
import 'package:mekinaparking/ui/chat/inbox_screen.dart';
import 'package:mekinaparking/ui/contact_us/contact_us_screen.dart';
import 'package:mekinaparking/ui/faq/faq_screen.dart';
import 'package:mekinaparking/ui/payment_history/payment_transaction_history_screen.dart';
import 'package:mekinaparking/ui/profile/edit_profile_screen.dart';
import 'package:mekinaparking/ui/refer_and_earn/refer_and_earn_screen.dart';
import 'package:mekinaparking/ui/setting_screen/setting_screen.dart';
import 'package:mekinaparking/ui/subscription/active_subscription_screen.dart';
import 'package:mekinaparking/ui/subscription/purchase_subscription.dart';
import 'package:mekinaparking/ui/terms_and_condition/terms_and_condition_screen.dart';
import 'package:mekinaparking/ui/vehicle_qr/vehicle_qr.dart';
import 'package:mekinaparking/ui/wallet/wallet_screen.dart';
import 'package:mekinaparking/utils/dark_theme_provider.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';
import 'package:mekinaparking/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface().customAppBar(
              context,
              themeChange,
              isBack: false,
              'profile'.tr,
              actions: [
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.to(const InboxScreen());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.chat_bubble_outline, color: themeChange.getThem() ? AppThemData.grey01 : AppThemData.grey08),
                  ),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: NetworkImageWidget(
                                    imageUrl: controller.userModel.value.profilePic.toString(),
                                    height: Responsive.width(26, context),
                                    width: Responsive.width(26, context),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.userModel.value.fullName.toString(),
                                      style: TextStyle(fontSize: 20, fontFamily: AppThemData.medium, color: themeChange.getThem() ? AppThemData.grey01 : AppThemData.grey10),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      controller.userModel.value.email.toString(),
                                      style: TextStyle(fontSize: 14, fontFamily: AppThemData.medium, color: themeChange.getThem() ? AppThemData.grey06 : AppThemData.grey06),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    RoundedButtonFill(
                                      title: "Edit Details".tr,
                                      textColor: Colors.white,
                                      width: 40,
                                      height: 05.55,
                                      isRight: false,
                                      icon: const Icon(Icons.edit, color:  Colors.white),
                                      color: AppThemData.primary06,
                                      onPress: () {
                                        Get.to(const EditProfileScreen());
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // menuItemWidget(
                          //   title: "My Booking".tr,
                          //   svgImage: "assets/icon/ic_booking.svg",
                          //   onTap: () {
                          //     Get.to(() => const MyBookingScreen(isBack: true));
                          //   },
                          //   themeChange: themeChange,
                          // ),
                          // menuItemWidget(
                          //   title: "My Booking List".tr,
                          //   svgImage: "assets/icon/ic_my_booking_list.svg",
                          //   onTap: () {
                          //     Get.to(() => const MyParkingBooingScreen());
                          //   },
                          //   themeChange: themeChange,
                          // ),
                          menuItemWidget(
                            title: "Wallet".tr,
                            svgImage: "assets/icon/ic_wallet.svg",
                            onTap: () {
                              Get.to(() => const WalletScreen());
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Transaction History".tr,
                            svgImage: "assets/icon/ic_my_booking_list.svg",
                            onTap: () {
                              Get.to(() => const PaymentTransactionHistoryScreen());
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Vehicle Qr".tr,
                            svgImage: "assets/icon/ic_car_image.svg",
                            onTap: () {
                              Get.to(() => const VehicleQrScreen());
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Subscription".tr,
                            svgImage: "assets/icon/ic_subscription.svg",
                            onTap: () async {
                              UserModel? user = await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid());
                              final expiry = user?.subscriptionExpiryDate;

                              if (expiry == null || expiry.toDate().isBefore(DateTime.now())) {
                                Get.to(() => const PurchaseSubscriptionScreen());
                              } else {
                                SubscriptionModel? plan = user?.subscriptionPlan;
                                String planDuration = "${plan?.plan?.first.months ?? "0"} Months";
                                String price = '${Constant.currencyModel?.symbol}${plan?.plan?.first.price ?? "0"}';

                                Get.to(() => ActiveSubscriptionScreen(
                                  planDuration: planDuration,
                                  createdDate: plan?.createdAt?.toDate() ?? DateTime.now(),
                                  expiryDate: expiry.toDate(),
                                  price: price,
                                ));
                              }
                              // Get.to(() => const PurchaseSubscriptionScreen());
                            },
                            themeChange: themeChange,
                          ),
                          // menuItemWidget(
                          //   title: "Bank Details".tr,
                          //   svgImage: "assets/icon/ic_bank.svg",
                          //   onTap: () {
                          //     Get.to(() => const BankDetailsScreen());
                          //   },
                          //   themeChange: themeChange,
                          // ),
                          const Divider(color: AppThemData.grey04, thickness: 1),
                          menuItemWidget(
                            title: "Settings".tr,
                            svgImage: "assets/icon/ic_setting.svg",
                            onTap: () {
                              Get.to(() => const SettingScreen());
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Refer and Earn".tr,
                            svgImage: "assets/icon/ic_refer_and_eran.svg",
                            onTap: () {
                              Get.to(() => const ReferAndEarnScreen());
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Privacy Policy".tr,
                            svgImage: "assets/icon/ic_privacy_policy.svg",
                            onTap: () {
                              Get.to(const TermsAndConditionScreen(
                                type: "privacy",
                              ));
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Terms & Conditions".tr,
                            svgImage: "assets/icon/ic_terms_condition.svg",
                            onTap: () {
                              Get.to(const TermsAndConditionScreen(
                                type: "terms",
                              ));
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Support".tr,
                            svgImage: "assets/icon/ic_support.svg",
                            onTap: () async {
                              final Uri url = Uri.parse(Constant.supportURL.toString());
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch ${Constant.supportURL.toString()}'.tr);
                              }
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "Contact us".tr,
                            svgImage: "assets/icon/ic_call_support.svg",
                            onTap: () {
                              Get.to(
                                () => const ContactUsScreen(),
                              );
                            },
                            themeChange: themeChange,
                          ),
                          menuItemWidget(
                            title: "FAQ’s".tr,
                            svgImage: "assets/icon/ic_faq.svg",
                            onTap: () {
                              Get.to(() => const FaqScreen());
                            },
                            themeChange: themeChange,
                          ),
                          const Divider(color: AppThemData.grey04, thickness: 1),
                          menuItemWidget(
                            title: "Log Out".tr,
                            svgImage: "assets/icon/ic_logout.svg",
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                      title: "Signing out for now?".tr,
                                      descriptions: "Ensure your account's security with a quick log out. Your parking solutions will be here when you return!".tr,
                                      positiveString: "Log out".tr,
                                      negativeString: "Cancel".tr,
                                      positiveClick: () async {
                                        await FirebaseAuth.instance.signOut();
                                        Get.offAll(const LoginScreen());
                                      },
                                      negativeClick: () {
                                        Get.back();
                                      },
                                      img: SvgPicture.asset('assets/images/ic_logout_image.svg'),
                                    );
                                  });
                              // showLogoutAccountDialog(context, themeChange);
                            },
                            themeChange: themeChange,
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  Widget menuItemWidget({
    required String svgImage,
    required String title,
    required VoidCallback onTap,
    required themeChange,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      horizontalTitleGap: 6,
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      leading: SvgPicture.asset(
        svgImage,
        color: title == "Log Out"
            ? AppThemData.error08
            : themeChange.getThem()
                ? AppThemData.grey01
                : AppThemData.grey09,
        height: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontFamily: AppThemData.medium,
            color: title == "Log Out"
                ? AppThemData.error08
                : themeChange.getThem()
                    ? AppThemData.grey01
                    : AppThemData.grey09),
      ),
    );
  }
}
