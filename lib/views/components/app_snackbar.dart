import 'package:flutter/material.dart';

enum AppSnackbarStatus { success, error, warning }

class AppSnackbar {
  static final AppSnackbar _instance = AppSnackbar._internal();

  factory AppSnackbar() {
    return _instance;
  }

  AppSnackbar._internal();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required String text,
    required AppSnackbarStatus status,
    required BuildContext context,
    void Function()? onVisible,
    int seconds = 2,
    SnackBarAction? action,
    double marginBottom = 0.0,
  }) {
    Color? bgColor;
    IconData? icon;

    if (status == AppSnackbarStatus.success) {
      bgColor = Colors.green;
      icon = Icons.check_circle;
    } else if (status == AppSnackbarStatus.warning) {
      bgColor = Colors.orange;
      icon = Icons.warning;
    } else if (status == AppSnackbarStatus.error) {
      bgColor = Colors.red;
    }

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        showCloseIcon: false,
        backgroundColor: bgColor,
        content: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 8),
              blurRadius: 18,
              spreadRadius: 0,
            ),
          ],),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    text,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.3,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
        onVisible: onVisible,
        action: action,
        duration: Duration(seconds: seconds),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.only(
          left: 24,
          top: 24,
          right: 24,
          bottom: 24 + marginBottom,
        ),
        elevation: 0,
      ),
    );
  }

}
