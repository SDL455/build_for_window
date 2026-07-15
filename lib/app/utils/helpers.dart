import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Helpers {
  static void showError(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10);
  }

  static void showSuccess(String message) {
    Get.snackbar('Success', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF22C55E),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10);
  }

  static void showInfo(String message) {
    Get.snackbar('Info', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF3B82F6),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10);
  }

  static Future<bool> confirm({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    Color confirmColor = const Color(0xFF5B2BE0),
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static String formatCurrency(double value, {String symbol = '\$'}) {
    final f = NumberFormat.currency(locale: 'en_US', symbol: symbol, decimalDigits: 2);
    return f.format(value);
  }

  static String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy, HH:mm').format(date);

  static String initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Generic admin dialog form builder.
  /// [onSubmit] should return `true` to close the dialog on success.
  static Future<T?> showFormDialog<T>({
    required String title,
    required List<Widget> fields,
    required String confirmText,
    required Future<bool> Function() onSubmit,
  }) async {
    return await Get.dialog<T>(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: fields),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final close = await onSubmit();
              if (close && Get.isDialogOpen == true) Get.back();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
