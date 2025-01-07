import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UtillFunctions {
  void snackbar(String title, String subtitle) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        title,
        subtitle,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }
}
