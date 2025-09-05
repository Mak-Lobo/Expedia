import 'package:flutter/material.dart';

// Renamed to lowerCamelCase as per Dart conventions for functions
SnackBar customSnackBar({
  required String message,
  Color? backgroundColor,
  // Add BuildContext if you need to access Theme for default colors inside here
  // required BuildContext context,
}) {
  return SnackBar(
    content: Text(message, softWrap: true),
    duration: const Duration(milliseconds: 1500),
    behavior: SnackBarBehavior.floating,
    width: 200,
    backgroundColor:
        backgroundColor, // SnackBar handles default color if this is null
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}
