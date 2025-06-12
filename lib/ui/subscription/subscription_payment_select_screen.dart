import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mekinaparking/constant/constant.dart';
import 'package:mekinaparking/constant/show_toast_dialog.dart';
import 'package:mekinaparking/controller/subscription_payament_select_controller.dart';
import 'package:mekinaparking/model/payment/xenditModel.dart';
import 'package:mekinaparking/model/payment_transaction_model.dart';
import 'package:mekinaparking/model/subscription_history_model.dart';
import 'package:mekinaparking/model/subscription_model.dart';
import 'package:mekinaparking/model/user_model.dart';
import 'package:mekinaparking/model/wallet_transaction_model.dart';
import 'package:mekinaparking/payment/MercadoPagoScreen.dart';
import 'package:mekinaparking/payment/PayFastScreen.dart';
import 'package:mekinaparking/payment/createRazorPayOrderModel.dart';
import 'package:mekinaparking/payment/getPaytmTxtToken.dart';
import 'package:mekinaparking/payment/midtrans_screen.dart';
import 'package:mekinaparking/payment/orangePayScreen.dart';
import 'package:mekinaparking/payment/paystack/pay_stack_screen.dart';
import 'package:mekinaparking/payment/paystack/pay_stack_url_model.dart';
import 'package:mekinaparking/payment/paystack/paystack_url_genrater.dart';
import 'package:mekinaparking/payment/rozorpayConroller.dart';
import 'package:mekinaparking/payment/xenditScreen.dart';
import 'package:mekinaparking/themes/app_them_data.dart';
import 'package:mekinaparking/themes/common_ui.dart';
import 'package:mekinaparking/themes/round_button_fill.dart';
import 'package:mekinaparking/ui/subscription/active_subscription_screen.dart';
import 'package:mekinaparking/utils/dark_theme_provider.dart';
import 'package:mekinaparking/utils/fire_store_utils.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

class SubscriptionPaymentSelectScreen extends StatelessWidget {
  SubscriptionPaymentSelectScreen({super.key});

  final price = Get.arguments['price'] as String;
  final subscriptionId = Get.arguments['subscriptionId'] as String;
  final months = Get.arguments['months'] as String;
  final id = Get.arguments['id'] as String;
  final maxSpace = Get.arguments['maxSpace'] as String;
  final ownerId = Get.arguments['ownerId'] as String;
  final parkingId = Get.arguments['parkingId'] as String;
  final title = Get.arguments['title'] as String;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SubscriptionPaymentSelectController>(
        init: SubscriptionPaymentSelectController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface()
                .customAppBar(context, themeChange, "Select Payment Method".tr),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.isLoading.value
                        ? Constant.loader()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.wallet !=
                                              null &&
                                          controller.paymentModel.value.wallet!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller.paymentModel.value.wallet!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/wallet.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.strip !=
                                              null &&
                                          controller.paymentModel.value.strip!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller.paymentModel.value.strip!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/strip.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.paypal !=
                                              null &&
                                          controller.paymentModel.value.paypal!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller.paymentModel.value.paypal!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/paypal.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.payStack !=
                                              null &&
                                          controller.paymentModel.value
                                                  .payStack!.enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.payStack!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/paystack.png"),
                                ),
                                Visibility(
                                  visible: controller
                                              .paymentModel.value.mercadoPago !=
                                          null &&
                                      controller.paymentModel.value.mercadoPago!
                                              .enable ==
                                          true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.mercadoPago!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/mercadopogo.png"),
                                ),
                                Visibility(
                                  visible: controller
                                              .paymentModel.value.flutterWave !=
                                          null &&
                                      controller.paymentModel.value.flutterWave!
                                              .enable ==
                                          true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.flutterWave!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/flutterwave.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.arifpay !=
                                              null &&
                                          controller.paymentModel.value.arifpay!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      "Telebirr",
                                      themeChange,
                                      "assets/images/telebirr.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.arifpay !=
                                              null &&
                                          controller.paymentModel.value.arifpay!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(controller, "MPesa",
                                      themeChange, "assets/images/mpesa.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.arifpay !=
                                              null &&
                                          controller.paymentModel.value.arifpay!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(controller, "CBE",
                                      themeChange, "assets/images/cbe.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.payfast !=
                                              null &&
                                          controller.paymentModel.value.payfast!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.payfast!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/payfast.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.razorpay !=
                                              null &&
                                          controller.paymentModel.value
                                                  .razorpay!.enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.razorpay!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/rezorpay.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.xendit !=
                                              null &&
                                          controller.paymentModel.value.xendit!
                                                  .enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller.paymentModel.value.xendit!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/xendit.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.orangePay !=
                                              null &&
                                          controller.paymentModel.value
                                                  .orangePay!.enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.orangePay!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/orangeMoney.png"),
                                ),
                                Visibility(
                                  visible:
                                      controller.paymentModel.value.midtrans !=
                                              null &&
                                          controller.paymentModel.value
                                                  .midtrans!.enable ==
                                              true,
                                  child: cardDecoration(
                                      controller,
                                      controller
                                          .paymentModel.value.midtrans!.name
                                          .toString(),
                                      themeChange,
                                      "assets/images/midtrans.png"),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              color: themeChange.getThem()
                  ? AppThemData.grey10
                  : AppThemData.grey11,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: RoundedButtonFill(
                  title:
                      "Pay ${double.parse(price.toString()).toStringAsFixed(Constant.currencyModel!.decimalDigits!)}"
                          .tr,
                  color: AppThemData.primary06,
                  onPress: () async {
                    if (controller.selectedPaymentMethod.value == "Telebirr") {
                      await showPhoneNumberDialog(
                          context,
                          double.parse(price.toString()).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        "MPesa") {
                      await showMPesaPhoneNumberDialog(
                          context,
                          double.parse(price.toString()).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        "CBE") {
                      await showCbePhoneNumberDialog(
                          context,
                          double.parse(price).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.paypal!.name) {
                      paypalPaymentSheet(double.parse(price).toStringAsFixed(
                          Constant.currencyModel!.decimalDigits!));
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.payStack!.name) {
                      payStackPayment(
                          double.parse(price).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.mercadoPago!.name) {
                      mercadoPagoMakePayment(
                          context: context,
                          amount: double.parse(price).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller: controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.flutterWave!.name) {
                      flutterWaveInitiatePayment(
                          context: context,
                          amount: double.parse(price).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller: controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.payfast!.name) {
                      payFastPayment(
                          context: context,
                          amount: double.parse(price).toStringAsFixed(
                              Constant.currencyModel!.decimalDigits!),
                          controller: controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.xendit!.name) {
                      xenditPayment(context, double.parse(price), controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.orangePay!.name) {
                      orangeMakePayment(
                          amount: double.parse(price).toString(),
                          context: context,
                          controller: controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.midtrans!.name) {
                      midtransMakePayment(
                          amount: double.parse(price).toString(),
                          context: context,
                          controller: controller);
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.razorpay!.name) {
                      RazorPayController()
                          .createOrderRazorPay(
                              amount: double.parse(price).toInt(),
                              razorpayModel:
                                  controller.paymentModel.value.razorpay)
                          .then((value) {
                        if (value == null) {
                          Get.back();
                          ShowToastDialog.showToast(
                              "Something went wrong, please contact admin.".tr);
                        } else {
                          CreateRazorPayOrderModel result = value;
                          openCheckout(
                              amount: double.parse(price).toInt(),
                              orderId: result.id,
                              controller: controller);
                        }
                      });
                    } else if (controller.selectedPaymentMethod.value ==
                        controller.paymentModel.value.wallet!.name) {
                      if (double.parse(controller.userModel.value.walletAmount
                              .toString()) >=
                          double.parse(price)) {
                        completeOrder(controller, price, subscriptionId, months,
                            id, maxSpace, ownerId, parkingId, title);
                      } else {
                        ShowToastDialog.showToast(
                            "Wallet Amount Insufficient".tr);
                      }
                    }
                  },
                ),
              ),
            ),
          );
        });
  }

  completeOrder(
      SubscriptionPaymentSelectController controller,
      String price,
      String subscriptionId,
      String months,
      String id,
      String maxSpace,
      String ownerId,
      String parkingId,
      String title) async {
    ShowToastDialog.showLoader("please wait".tr);
    UserModel userModelData = controller.userModel.value;
    userModelData.subscriptionPlanId = subscriptionId.toString();
    userModelData.subscriptionExpiryDate =
        controller.calculateExpiryDate(months ?? "0");
    userModelData.subscriptionPlan ??= SubscriptionModel();
    userModelData.expiryNotice = false;

    SubscriptionModel subscriptionModelData = SubscriptionModel(
        id: id,
        createdAt: Timestamp.now(),
        isEnable: true,
        maxSpace: maxSpace,
        ownerId: ownerId,
        parkingId: parkingId,
        title: title,
        plan: [
          Plan(
            months: months,
            price: price,
          )
        ]);
    SubscriptionHistoryModel subscriptionHistoryModel =
        SubscriptionHistoryModel(
            id: subscriptionId.toString(),
            userId: userModelData.id.toString(),
            paymentStatus: 'paid',
            createdAt: Timestamp.now(),
            expiryDate: controller.calculateExpiryDate(months ?? "0"),
            subscriptionPlan: subscriptionModelData);

    if (controller.selectedPaymentMethod.value !=
        controller.paymentModel.value.wallet!.name) {
      PaymentTransactionModel paymentTransactionModel = PaymentTransactionModel(
          id: Constant.getUuid(),
          amount: double.parse(price.toString()).toString(),
          createdDate: Timestamp.now(),
          paymentType: controller.selectedPaymentMethod.value,
          isCredit: false,
          userId: FireStoreUtils.getCurrentUid(),
          note: "Subscription amount debit");

      await FireStoreUtils.setPaymentTransaction(paymentTransactionModel)
          .then((value) async {});
    }

    if (controller.selectedPaymentMethod.value ==
        controller.paymentModel.value.wallet!.name) {
      String walletPrice =
          (double.parse(controller.userModel.value.walletAmount.toString()) -
                  double.parse(price.toString()))
              .toString();
      userModelData.walletAmount = walletPrice;
      WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: double.parse(price.toString()).toString(),
          createdDate: Timestamp.now(),
          paymentType: controller.selectedPaymentMethod.value,
          isCredit: false,
          userId: FireStoreUtils.getCurrentUid(),
          note: "Subscription amount debit");

      await FireStoreUtils.setWalletTransaction(adminCommissionWallet)
          .then((value) async {
        if (value == true) {
          await FireStoreUtils.updateUserWallet(
            amount: double.parse(price.toString()).toString(),
          );
        }
      });
    }

    userModelData.subscriptionPlan = subscriptionModelData;
    Timestamp expiryTimestamp = controller.calculateExpiryDate(months ?? "0");
    DateTime expiryDate = expiryTimestamp.toDate();
    String priceText = '${Constant.currencyModel!.symbol}${price.toString()}';

    await FireStoreUtils.updateUser(userModelData).then((value) async {
      ShowToastDialog.closeLoader();
      if (value == true) {
        ShowToastDialog.closeLoader();
        Get.back();
        await Future.delayed(Duration(milliseconds: 100));
        Get.off(() => ActiveSubscriptionScreen(
              planDuration: '${months.toString()} Months',
              createdDate: DateTime.now(),
              expiryDate: expiryDate,
              price: priceText,
            ));
        ShowToastDialog.showToast("Subscription purchased successfully!");
      }
    });
    await FireStoreUtils.saveSubscriptionDetails(
        subscriptionHistoryModel, subscriptionId.toString());
  }

  cardDecoration(SubscriptionPaymentSelectController controller, String value,
      themeChange, String image) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () {
              controller.selectedPaymentMethod.value = value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    decoration: BoxDecoration(
                        color: themeChange.getThem()
                            ? AppThemData.grey10
                            : AppThemData.grey03,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      image,
                      width: 80,
                      height: 36,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: themeChange.getThem()
                              ? AppThemData.grey01
                              : AppThemData.grey08),
                    ),
                  ),
                  if (value.toLowerCase() == 'wallet'.toLowerCase())
                    Text(
                        Constant.amountShow(
                            amount: controller.userModel.value.walletAmount),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppThemData.semiBold,
                            color: themeChange.getThem()
                                ? AppThemData.grey01
                                : AppThemData.grey10)),
                  Radio(
                    value: value.toString(),
                    groupValue: controller.selectedPaymentMethod.value,
                    activeColor: themeChange.getThem()
                        ? AppThemData.primary08
                        : AppThemData.primary08,
                    onChanged: (value) {
                      controller.selectedPaymentMethod.value = value.toString();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPhoneNumberDialog(BuildContext context, String amount,
      SubscriptionPaymentSelectController controller) async {
    final TextEditingController phoneNumberController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Telebirr Phone Number'),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '+251 ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String phoneNumber = phoneNumberController.text.trim();
                if (phoneNumber.length == 9) {
                  Get.back();
                  createArifPayPayment(
                      amount: amount,
                      context: context,
                      phoneNumber: '251$phoneNumber',
                      controller: controller // Prefix with +251
                      );
                } else {
                  ShowToastDialog.showToast(
                      "Please enter a valid phone number with 9 digits");
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  // ArifPay
  Future<void> createArifPayPayment(
      {required String amount,
      required BuildContext context,
      required String phoneNumber,
      required SubscriptionPaymentSelectController controller}) async {
    final url =
        'https://gateway.arifpay.net/api/checkout/telebirr-ussd/transfer/direct';
    String apikey = controller.paymentModel.value.arifpay!.apiKey.toString();

    final headers = {
      'Content-Type': 'application/json',
      'x-arifpay-key': apikey.toString(),
    };

    final nonce = generateNonce();
    final body = jsonEncode({
      "cancelUrl": "https://example.com",
      "phone": phoneNumber,
      // "phone": "251911287144", //mekina client Arifpay Number
      // "phone": "251983832880", //arifpay client number
      "email": controller.userModel.value.email.toString(),
      "nonce": nonce.toString(),
      "errorUrl": "http://error.com",
      "notifyUrl": "https://mekinaparking.com/admin/arifpay/notify",
      "successUrl": "https://mekinaparking.com/admin/arifpay/success",
      "paymentMethods": [
        "TELEBIRR_USSD" // Don't change this
      ],
      "expireDate": "2080-02-01T03:45:27",
      "items": [
        {
          "name": "test",
          "quantity": 1,
          "price": amount.toString(),
          "description": "",
          "image": ""
        }
      ],
      "beneficiaries": [
        {
          "accountNumber": "01320811436100", // dont change
          "bank": "AWINETAA", //dont change
          "amount": amount.toString()
        }
      ],
      "lang": "EN"
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final notifyUrl =
          data['data']['transaction']['checkoutSession']['notifyUrl'];
      final transaction =
          data['data']['transaction']['checkoutSession']['uuid'];
      if (notifyUrl != null) {
        log("Notify URL found: $notifyUrl");
        ShowToastDialog.showLoader("Payment Processing...");
        await checkPaymentStatus(transaction, controller);
      } else {
        log("Success URL is null");
      }
    } else {
      print('Error creating preference: ${response.body}');
      return null;
    }
  }

  Future<void> showMPesaPhoneNumberDialog(BuildContext context, String amount,
      SubscriptionPaymentSelectController controller) async {
    final TextEditingController phoneNumberController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter MPesa Phone Number'),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '+251 ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String phoneNumber = phoneNumberController.text.trim();
                if (phoneNumber.length == 9) {
                  Get.back();
                  createMPesaPayment(
                      amount: amount,
                      context: context,
                      phoneNumber: '251$phoneNumber',
                      controller: controller // Prefix with +251
                      );
                } else {
                  ShowToastDialog.showToast(
                      "Please enter a valid phone number with 9 digits");
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showCbePhoneNumberDialog(BuildContext context, String amount,
      SubscriptionPaymentSelectController controller) async {
    final TextEditingController phoneNumberController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter CBE Phone Number'),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '+251 ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String phoneNumber = phoneNumberController.text.trim();
                if (phoneNumber.length == 9) {
                  Get.back();
                  createCbeSessionIdPayment(
                      amount: amount,
                      context: context,
                      phoneNumber: '251$phoneNumber',
                      controller: controller // Prefix with +251
                      );
                } else {
                  ShowToastDialog.showToast(
                      "Please enter a valid phone number with 9 digits");
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  //Mpesa
  Future<void> createMPesaPayment(
      {required String amount,
      required BuildContext context,
      required String phoneNumber,
      required SubscriptionPaymentSelectController controller}) async {
    final url =
        'https://gateway.arifpay.net/api/checkout/mpesa/transfer/direct';
    String apikey = controller.paymentModel.value.arifpay!.apiKey.toString();

    final headers = {
      'Content-Type': 'application/json',
      'x-arifpay-key': apikey.toString(),
    };

    final nonce = generateNonce();
    final body = jsonEncode({
      "cancelUrl": "https://example.com",
      "phone": phoneNumber,
      // "phone": "251911287144", //client Arifpay Number
      "email": controller.userModel.value.email.toString(),
      "nonce": nonce.toString(),
      // auto generate a unique value for this
      "errorUrl": "http://error.com",
      "notifyUrl": "https://mekinaparking.com/admin/arifpay/notify",
      "successUrl": "https://mekinaparking.com/admin/arifpay/success",
      "paymentMethods": [
        "MPESA" // Don't change this
      ],
      "expireDate": "2080-02-01T03:45:27",
      // look out for the format of the expire date
      "items": [
        {
          "name": "test",
          "quantity": 1,
          "price": amount.toString(),
          "description": "",
          "image": ""
        }
      ],
      "beneficiaries": [
        {
          "accountNumber": "01320811436100", // dont change
          "bank": "AWINETAA", //dont change
          "amount": amount.toString()
        }
      ],
      "name": "Belay",
      "lang": "EN"
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final notifyUrl =
          data['data']['transaction']['checkoutSession']['notifyUrl'];
      final transaction =
          data['data']['transaction']['checkoutSession']['uuid'];
      if (notifyUrl != null) {
        log("Notify URL found: $notifyUrl");
        ShowToastDialog.showLoader("Payment Processing...");
        await checkPaymentStatus(transaction, controller);
      } else {
        log("Success URL is null");
      }
    } else {
      print('Error creating preference: ${response.body}');
      return null;
    }
  }

  //CBE session ID create
  Future<void> createCbeSessionIdPayment(
      {required String amount,
      required BuildContext context,
      required String phoneNumber,
      required SubscriptionPaymentSelectController controller}) async {
    final url = 'https://gateway.arifpay.net/api/checkout/session';
    String apikey = controller.paymentModel.value.arifpay!.apiKey.toString();

    final headers = {
      'Content-Type': 'application/json',
      'x-arifpay-key': apikey.toString(),
    };

    final nonce = generateNonce();
    final body = jsonEncode({
      "cancelUrl": "https://example.com",
      "phone": phoneNumber,
      // "phone": "251911287144", //client Arifpay Number
      "email": controller.userModel.value.email.toString(),
      "nonce": nonce.toString(),
      // auto generate a unique value for this
      "errorUrl": "http://error.com",
      "notifyUrl": "https://mekinaparking.com/admin/arifpay/notify",
      "successUrl": "https://mekinaparking.com/admin/arifpay/success",
      "paymentMethods": [
        "CBE" // Don't change this
      ],
      "expireDate": "2080-02-01T03:45:27",
      // look out for the format of the expire date
      "items": [
        {
          "name": "test",
          "quantity": 1,
          "price": amount.toString(),
          "description": "",
          "image": ""
        }
      ],
      "beneficiaries": [
        {
          "accountNumber": "01320811436100", // dont change
          "bank": "AWINETAA", //dont change
          "amount": amount.toString()
        }
      ],
      "name": "Belay",
      "lang": "EN"
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final sessionId = data['data']['sessionId'];
      log("Notify URL found: $sessionId");
      ShowToastDialog.showLoader("Payment Processing...");
      await createCbeDirectPayment(
          sessionId: sessionId,
          phoneNumber: phoneNumber,
          controller: controller);
    } else {
      log("Success URL is null");
    }
  }

  //CBE Payment
  Future<void> createCbeDirectPayment(
      {required String sessionId,
      required String phoneNumber,
      required SubscriptionPaymentSelectController controller}) async {
    final url = 'https://gateway.arifpay.net/api/checkout/cbe/direct/transfer';
    String apikey = controller.paymentModel.value.arifpay!.apiKey.toString();

    final headers = {
      'Content-Type': 'application/json',
      'x-arifpay-key': apikey.toString(),
    };

    final body = jsonEncode({
      "phoneNumber": phoneNumber,
      "sessionId": sessionId,
      // "phone": "251911287144", //client Arifpay Number
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final transaction =
          data['data']['transaction']['checkoutSession']['uuid'];
      log("Notify URL found: $transaction");
      ShowToastDialog.showLoader("Payment Processing...");
      await checkPaymentStatus(transaction, controller);
    } else {
      log("Success URL is null");
    }
  }

  Future<void> checkPaymentStatus(String transactionUuid,
      SubscriptionPaymentSelectController controller) async {
    const int maxRetries = 10; // Number of retries before timeout
    const Duration delayBetweenRetries =
        Duration(seconds: 3); // Delay between each retry

    int retryCount = 0;
    bool isPaymentComplete = false;

    ShowToastDialog.showLoader("Checking Payment Status...");

    while (!isPaymentComplete && retryCount < maxRetries) {
      try {
        final response = await http.post(
          Uri.parse('https://mekinaparking.com/admin/arifpay/getPaymentData'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'uuid': transactionUuid}),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          final status = data['data'][0]['status'];

          if (status == 'success') {
            isPaymentComplete = true;
            ShowToastDialog.closeLoader();
            completeOrder(controller, price, subscriptionId, months, id,
                maxSpace, ownerId, parkingId, title);
            ShowToastDialog.showToast("Payment Successful!!");
            Get.back();
            log("Payment completion successful: ${response.body}");
          } else if (status == 'failed') {
            isPaymentComplete = true;
            ShowToastDialog.closeLoader();
            ShowToastDialog.showToast("Payment Unsuccessful!!");
          } else {
            log("Payment still pending, retrying...");
          }
        } else {
          log('Error checking payment status: ${response.body}');
        }
      } catch (e) {
        log('Error: $e');
      }

      if (!isPaymentComplete) {
        retryCount++;
        await Future.delayed(delayBetweenRetries);
      }
    }

    if (!isPaymentComplete) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Payment Timeout or Failed");
      log("Payment status check timed out.");
    }
  }

  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  void initPayPal(SubscriptionPaymentSelectController controller) async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode =
        controller.paymentModel.value.paypal!.isSandbox == true ? true : false;

    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.mekinaparking://paypalpay",
      //client id from developer dashboard
      clientID: controller.paymentModel.value.paypal!.paypalClient.toString(),
      //sandbox, staging, live etc
      payPalEnvironment: controller.paymentModel.value.paypal!.isSandbox == true
          ? FPayPalEnvironment.sandbox
          : FPayPalEnvironment.live,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          ShowToastDialog.showToast("Payment canceled");
        },
        onSuccess: (data) {
          //successfully paid
          //remove all items from queue
          _flutterPaypalNativePlugin.removeAllPurchaseItems();
          ShowToastDialog.showToast("Payment successfully");
          completeOrder(controller, price, subscriptionId, months, id, maxSpace,
              ownerId, parkingId, title);
        },
        onError: (data) {
          //an error occured
          ShowToastDialog.showToast("error: ${data.reason}");
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          ShowToastDialog.showToast(
              "shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}");
        },
      ),
    );
  }

  paypalPaymentSheet(String amount) {
    //add 1 item to cart. Max is 4!
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          // random prices
          amount: double.parse(amount),

          ///please use your own algorithm for referenceId. Maybe ProductID?
          referenceId: FPayPalStrHelper.getRandomString(16),
        ),
      );
    }
    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }

  // Future<void> stripeMakePayment(
  //     {required String amount,
  //     required SubscriptionPaymentSelectController controller}) async {
  //   log(double.parse(amount).toStringAsFixed(0));
  //   try {
  //     Map<String, dynamic>? paymentIntentData =
  //         await createStripeIntent(amount: amount, controller: controller);
  //     if (paymentIntentData!.containsKey("error")) {
  //       Get.back();
  //       ShowToastDialog.showToast(
  //           "Something went wrong, please contact admin.");
  //     } else {
  //       await Stripe.instance.initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //               paymentIntentClientSecret: paymentIntentData['client_secret'],
  //               allowsDelayedPaymentMethods: false,
  //               googlePay: const PaymentSheetGooglePay(
  //                 merchantCountryCode: 'US',
  //                 testEnv: true,
  //                 currencyCode: "USD",
  //               ),
  //               style: ThemeMode.system,
  //               customFlow: true,
  //               appearance: PaymentSheetAppearance(
  //                 colors: PaymentSheetAppearanceColors(
  //                   primary: AppThemData.primary06,
  //                 ),
  //               ),
  //               merchantDisplayName: 'MekinaParking'));
  //       displayStripePaymentSheet(amount: amount, controller: controller);
  //     }
  //   } catch (e, s) {
  //     log("$e \n$s");
  //     ShowToastDialog.showToast("exception:$e \n$s");
  //   }
  // }
  //
  // displayStripePaymentSheet(
  //     {required String amount,
  //     required SubscriptionPaymentSelectController controller}) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       ShowToastDialog.showToast("Payment successfully");
  //       completeOrder(
  //           controller, price, months, id, maxSpace, ownerId, parkingId, title);
  //     });
  //   } on StripeException catch (e) {
  //     var lo1 = jsonEncode(e);
  //     var lo2 = jsonDecode(lo1);
  //     StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
  //     ShowToastDialog.showToast(lom.error.message);
  //   } catch (e) {
  //     ShowToastDialog.showToast(e.toString());
  //   }
  // }

  createStripeIntent(
      {required String amount,
      required SubscriptionPaymentSelectController controller}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": controller.userModel.value.fullName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      log(controller.paymentModel.value.strip!.stripeSecret.toString());
      var stripeSecret = controller.paymentModel.value.strip!.stripeSecret;
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripeSecret',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

//mercadoo
  mercadoPagoMakePayment(
      {required BuildContext context,
      required String amount,
      required SubscriptionPaymentSelectController controller}) async {
    final headers = {
      'Authorization':
          'Bearer ${controller.paymentModel.value.mercadoPago!.accessToken}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "items": [
        {
          "title": "Test",
          "description": "Test Payment",
          "quantity": 1,
          "currency_id": "BRL", // or your preferred currency
          "unit_price": double.parse(amount),
        }
      ],
      "payer": {"email": controller.userModel.value.email.toString()},
      "back_urls": {
        "failure": "${Constant.globalUrl}payment/failure",
        "pending": "${Constant.globalUrl}payment/pending",
        "success": "${Constant.globalUrl}payment/success",
      },
      "auto_return": "approved"
      // Automatically return after payment is approved
    });

    final response = await http.post(
      Uri.parse("https://api.mercadopago.com/checkout/preferences"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final bool isDone = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MercadoPagoScreen(initialURl: data['init_point'])));

      if (isDone) {
        ShowToastDialog.showToast("Payment Successful!!");
        completeOrder(controller, price, subscriptionId, months, id, maxSpace,
            ownerId, parkingId, title);
      } else {
        ShowToastDialog.showToast("Payment UnSuccessful!!");
      }
    } else {
      print('Error creating preference: ${response.body}');
      return null;
    }
  }

  flutterWaveInitiatePayment(
      {required BuildContext context,
      required String amount,
      required SubscriptionPaymentSelectController controller}) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final headers = {
      'Authorization':
          'Bearer ${controller.paymentModel.value.flutterWave!.secretKey.toString().trim()}',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "tx_ref": controller.ref,
      "amount": amount,
      "currency": "NGN",
      "redirect_url": "${Constant.globalUrl}payment/success",
      "payment_options": "ussd, card, barter, payattitude",
      "customer": {
        "email": controller.userModel.value.email.toString(),
        "phonenumber": controller.userModel.value.phoneNumber.toString(),
        // Add a real phone number
        "name": controller.userModel.value.fullName.toString(),
        // Add a real customer name
      },
      "customizations": {
        "title": "Payment for Services",
        "description": "Payment for XYZ services",
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final bool isDone = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MercadoPagoScreen(initialURl: data['data']['link'])));

      if (isDone) {
        ShowToastDialog.showToast("Payment Successful!!");
        completeOrder(controller, price, subscriptionId, months, id, maxSpace,
            ownerId, parkingId, title);
      } else {
        ShowToastDialog.showToast("Payment UnSuccessful!!");
      }
    } else {
      print('Payment initialization failed: ${response.body}');
      return null;
    }
  }

  ///PayStack Payment Method
  payStackPayment(String totalAmount,
      SubscriptionPaymentSelectController controller) async {
    await PayStackURLGen.payStackURLGen(
            amount: (double.parse(totalAmount) * 100).toString(),
            currency: "NGN",
            secretKey:
                controller.paymentModel.value.payStack!.secretKey.toString(),
            userModel: controller.userModel.value)
        .then((value) async {
      if (value != null) {
        PayStackUrlModel payStackModel = value;
        Get.to(PayStackScreen(
          secretKey:
              controller.paymentModel.value.payStack!.secretKey.toString(),
          callBackUrl:
              controller.paymentModel.value.payStack!.callbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ))!
            .then((value) {
          if (value) {
            ShowToastDialog.showToast("Payment Successful!!");
            completeOrder(controller, price, subscriptionId, months, id,
                maxSpace, ownerId, parkingId, title);
          } else {
            ShowToastDialog.showToast("Payment UnSuccessful!!");
          }
        });
      } else {
        ShowToastDialog.showToast(
            "Something went wrong, please contact admin.");
      }
    });
  }

// payFast
  payFastPayment(
      {required BuildContext context,
      required String amount,
      required SubscriptionPaymentSelectController controller}) {
    PayStackURLGen.getPayHTML(
            payFastSettingData: controller.paymentModel.value.payfast!,
            amount: amount.toString(),
            userModel: controller.userModel.value)
        .then((String? value) async {
      bool isDone = await Get.to(PayFastScreen(
          htmlData: value!,
          payFastSettingData: controller.paymentModel.value.payfast!));
      if (isDone) {
        ShowToastDialog.showToast("Payment successfully");
        completeOrder(controller, price, subscriptionId, months, id, maxSpace,
            ownerId, parkingId, title);
      } else {
        ShowToastDialog.showToast("Payment Failed");
      }
    });
  }

  Future<GetPaymentTxtTokenModel> initiatePayment(
      {required double amount,
      required orderId,
      required SubscriptionPaymentSelectController controller}) async {
    String initiateURL = "${Constant.globalUrl}payments/initiatepaytmpayment";
    String callback = "";
    if (controller.paymentModel.value.paytm!.isSandbox == true) {
      callback =
          "${callback}https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    } else {
      callback =
          "${callback}https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    }
    final response =
        await http.post(Uri.parse(initiateURL), headers: {}, body: {
      "mid": controller.paymentModel.value.paytm!.paytmMID,
      "order_id": orderId,
      "key_secret": controller.paymentModel.value.paytm!.merchantKey,
      "amount": amount.toString(),
      "currency": "INR",
      "callback_url": callback,
      "custId": FireStoreUtils.getCurrentUid(),
      "issandbox":
          controller.paymentModel.value.paytm!.isSandbox == true ? "1" : "2",
    });
    log(response.body);
    final data = jsonDecode(response.body);
    if (data["body"]["txnToken"] == null ||
        data["body"]["txnToken"].toString().isEmpty) {
      Get.back();
      ShowToastDialog.showToast("something went wrong, please contact admin.");
    }
    return GetPaymentTxtTokenModel.fromJson(data);
  }

  ///RazorPay payment function

  void openCheckout(
      {required amount,
      required orderId,
      required SubscriptionPaymentSelectController controller}) async {
    var options = {
      'key': controller.paymentModel.value.razorpay!.razorpayKey,
      'amount': amount * 100,
      'name': 'MekinaParking',
      'order_id': orderId,
      "currency": "INR",
      'description': 'wallet Topup',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': controller.userModel.value.phoneNumber,
        'email': controller.userModel.value.email,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      controller.razorPay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

//XenditPayment
  xenditPayment(
      context, amount, SubscriptionPaymentSelectController controller) async {
    await createXenditInvoice(amount: amount, controller: controller)
        .then((model) {
      if (model.id != null) {
        Get.to(() => XenditScreen(
                  initialURl: model.invoiceUrl ?? '',
                  transId: model.id ?? '',
                  apiKey: controller.paymentModel.value.xendit!.apiKey!
                          .toString() ??
                      "",
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            completeOrder(controller, price, subscriptionId, months, id,
                maxSpace, ownerId, parkingId, title);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Payment Unsuccessful!! \n"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<XenditModel> createXenditInvoice(
      {required var amount,
      required SubscriptionPaymentSelectController controller}) async {
    const url = 'https://api.xendit.co/v2/invoices';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(
          controller.paymentModel.value.xendit!.apiKey!.toString()),
      // 'Cookie': '__cf_bm=yERkrx3xDITyFGiou0bbKY1bi7xEwovHNwxV1vCNbVc-1724155511-1.0.1.1-jekyYQmPCwY6vIJ524K0V6_CEw6O.dAwOmQnHtwmaXO_MfTrdnmZMka0KZvjukQgXu5B.K_6FJm47SGOPeWviQ',
    };

    final body = jsonEncode({
      'external_id': const Uuid().v1(),
      'amount': amount,
      'payer_email': 'customer@domain.com',
      'description': 'Test - VA Successful invoice payment',
      'currency': 'IDR', //IDR, PHP, THB, VND, MYR
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        XenditModel model = XenditModel.fromJson(jsonDecode(response.body));
        return model;
      } else {
        return XenditModel();
      }
    } catch (e) {
      return XenditModel();
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

//Orangepay payment
  static String accessToken = '';
  static String payToken = '';
  static String orderId = '';
  static String amount = '';

  orangeMakePayment(
      {required String amount,
      required BuildContext context,
      required SubscriptionPaymentSelectController controller}) async {
    reset();
    var id = const Uuid().v4();
    var paymentURL = await fetchToken(
        context: context,
        orderId: id,
        amount: amount,
        currency: 'USD',
        controller: controller);

    if (paymentURL.toString() != '') {
      Get.to(() => OrangeMoneyScreen(
                initialURl: paymentURL,
                accessToken: accessToken,
                amount: amount,
                orangePay: controller.paymentModel.value.orangePay!,
                orderId: orderId,
                payToken: payToken,
              ))!
          .then((value) {
        if (value == true) {
          ShowToastDialog.showToast("Payment Successful!!");
          completeOrder(controller, price, subscriptionId, months, id, maxSpace,
              ownerId, parkingId, title);
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Payment Unsuccessful!! \n"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future fetchToken(
      {required String orderId,
      required String currency,
      required BuildContext context,
      required String amount,
      required SubscriptionPaymentSelectController controller}) async {
    String apiUrl = 'https://api.orange.com/oauth/v3/token';
    Map<String, String> requestBody = {
      'grant_type': 'client_credentials',
    };

    var response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization':
              "Basic ${controller.paymentModel.value.orangePay!.auth!}",
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: requestBody);

    // Handle the response

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);

      accessToken = responseData['access_token'];
      // ignore: use_build_context_synchronously
      return await webpayment(
          context: context,
          amountData: amount,
          currency: currency,
          orderIdData: orderId,
          controller: controller);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.",
            style: TextStyle(fontSize: 17),
          )));

      return '';
    }
  }

  Future webpayment(
      {required String orderIdData,
      required BuildContext context,
      required String currency,
      required String amountData,
      required SubscriptionPaymentSelectController controller}) async {
    orderId = orderIdData;
    amount = amountData;
    String apiUrl = controller.paymentModel.value.orangePay!.isSandbox! == true
        ? 'https://api.orange.com/orange-money-webpay/dev/v1/webpayment'
        : 'https://api.orange.com/orange-money-webpay/cm/v1/webpayment';
    Map<String, String> requestBody = {
      "merchant_key":
          controller.paymentModel.value.orangePay!.merchantKey ?? '',
      "currency": controller.paymentModel.value.orangePay!.isSandbox == true
          ? "OUV"
          : currency,
      "order_id": orderId,
      "amount": amount,
      "reference": 'Y-Note Test',
      "lang": "en",
      "return_url":
          controller.paymentModel.value.orangePay!.returnUrl!.toString(),
      "cancel_url":
          controller.paymentModel.value.orangePay!.cancelUrl!.toString(),
      "notif_url":
          controller.paymentModel.value.orangePay!.notifyUrl!.toString(),
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(requestBody),
    );

    // Handle the response
    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['message'] == 'OK') {
        payToken = responseData['pay_token'];
        return responseData['payment_url'];
      } else {
        return '';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xff635bff),
          content: Text(
            "Something went wrong, please contact admin.",
            style: TextStyle(fontSize: 17),
          )));
      return '';
    }
  }

  static reset() {
    accessToken = '';
    payToken = '';
    orderId = '';
    amount = '';
  }

//Midtrans payment
  midtransMakePayment(
      {required String amount,
      required BuildContext context,
      required SubscriptionPaymentSelectController controller}) async {
    await createPaymentLink(amount: amount, controller: controller).then((url) {
      if (url != '') {
        Get.to(() => MidtransScreen(
                  initialURl: url,
                ))!
            .then((value) {
          if (value == true) {
            ShowToastDialog.showToast("Payment Successful!!");
            completeOrder(controller, price, subscriptionId, months, id,
                maxSpace, ownerId, parkingId, title);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Payment Unsuccessful!! \n"),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    });
  }

  Future<String> createPaymentLink(
      {required var amount,
      required SubscriptionPaymentSelectController controller}) async {
    var ordersId = const Uuid().v1();
    final url = Uri.parse(controller.paymentModel.value.midtrans!.isSandbox!
        ? 'https://api.sandbox.midtrans.com/v1/payment-links'
        : 'https://api.midtrans.com/v1/payment-links');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': generateBasicAuthHeader(
            controller.paymentModel.value.midtrans!.serverKey!),
      },
      body: jsonEncode({
        'transaction_details': {
          'order_id': ordersId,
          'gross_amount': double.parse(amount.toString()).toInt(),
        },
        'usage_limit': 2,
        "callbacks": {
          "finish": "https://www.google.com?merchant_order_id=$ordersId"
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Payment link created: ${responseData['payment_url']}');
      return responseData['payment_url'];
    } else {
      return '';
    }
  }
}
