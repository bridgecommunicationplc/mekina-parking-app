import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:mekinaparking/themes/app_them_data.dart';
import 'package:mekinaparking/themes/common_ui.dart';
import 'package:mekinaparking/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class ActiveSubscriptionScreen extends StatelessWidget {
  final String planDuration;
  final DateTime createdDate;
  final DateTime expiryDate;
  final String price;

  const ActiveSubscriptionScreen({
    super.key,
    required this.planDuration,
    required this.createdDate,
    required this.expiryDate,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final now = DateTime.now();
    final remainingDays = expiryDate.difference(now).inDays;
    final isActive = remainingDays > 0;

    String formatDate(DateTime date) {
      return DateFormat('MMM d, yyyy').format(date);
    }

    return Scaffold(
      appBar: UiInterface().customAppBar(
        context,
        themeChange,
        'Subscription Details'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 250,
          child: Card(
            color:
                themeChange.getThem() ? AppThemData.grey10 : AppThemData.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  infoRow("Plan:", planDuration),
                  infoRow("Created On:", formatDate(createdDate)),
                  infoRow("Expires On:", formatDate(expiryDate)),
                  infoRow("Price:", price.toString()),
                  infoRow("Remaining:", "$remainingDays days"),
                  infoRow("Status:", isActive ? "✅ Active" : "❌ Expired"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppThemData.semiBold,
                  fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppThemData.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
