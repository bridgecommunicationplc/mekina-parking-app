import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mekinaparking/model/admin_commission.dart';
import 'package:mekinaparking/model/subscription_model.dart';

class UserModel {
  String? fullName;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? fcmToken;
  String? countryCode;
  String? phoneNumber;
  String? walletAmount;
  String? gender;
  bool? isActive;
  Timestamp? createdAt;
  String? role;
  bool? expiryNotice;
  String? subscriptionPlanId;
  Timestamp? subscriptionExpiryDate;
  SubscriptionModel? subscriptionPlan;
  AdminCommission? adminCommission;

  UserModel(
      {this.fullName,
      this.id,
      this.isActive,
      this.dateOfBirth,
      this.email,
      this.loginType,
      this.profilePic,
      this.fcmToken,
      this.countryCode,
      this.phoneNumber,
      this.walletAmount,
      this.createdAt,
      this.role,
      this.expiryNotice,
      this.adminCommission,
      this.subscriptionPlanId,
      this.subscriptionExpiryDate,
      this.subscriptionPlan});

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['id'];
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    walletAmount = json['walletAmount'] ?? "0";
    createdAt = json['createdAt'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'] ?? '';
    isActive = json['isActive'];
    role = json['role'];
    expiryNotice = json['expiry_notice'];
    adminCommission = json['commission'] != null
        ? AdminCommission.fromJson(json['commission'])
        : null;
    subscriptionPlanId = json['subscriptionPlanId'];
    subscriptionExpiryDate = json['subscriptionExpiryDate'];
    subscriptionPlan = json['subscription_plan'] != null
        ? SubscriptionModel.fromJson(json['subscription_plan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isActive'] = isActive;
    data['role'] = role;
    data['expiry_notice'] = expiryNotice;
    if (adminCommission != null) {
      data['commission'] = adminCommission!.toJson();
    }
    data['subscriptionPlanId'] = subscriptionPlanId;
    data['subscriptionExpiryDate'] = subscriptionExpiryDate;
    data['subscription_plan'] = subscriptionPlan?.toJson();
    return data;
  }
}
