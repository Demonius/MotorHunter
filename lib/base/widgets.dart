import 'package:flutter/material.dart';
import 'package:motor_hunter/constants/string_constants.dart';

AppBar defaultAppBar({List<Widget>? actions}) => AppBar(
      title: const Text(StringResources.appName),
      actions: actions,
    );

FloatingActionButton addFloatingActionButton(String? tooltip, VoidCallback? onPressed) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: tooltip,
    child: const Icon(Icons.add),
  );
}

void showSnackBar(BuildContext context, String text) {
  SnackBar snackBar = SnackBar(
    content: Text(text),
    duration: const Duration(milliseconds: 700),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackBar(BuildContext context, String text) {
  SnackBar snackBar = SnackBar(
    backgroundColor: Colors.red,
    content: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    duration: const Duration(milliseconds: 1000),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget createWidgetTitleValue(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        title,
        style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
      ),
      Text(value)
    ],
  );
}
