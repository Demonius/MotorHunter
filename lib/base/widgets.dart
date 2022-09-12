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

Widget imageFromExternal(String url, {double height = 100.0, double width = 60.0}) {
  double radiusCard = 8.0;
  return SizedBox(
      width: width,
      height: height,
      child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard),
          ),
          child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(radiusCard),
                  child: Image.network(url, width: width, height: height, fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? event) {
                    if (event == null) return child;
                    var progress = event.expectedTotalBytes != null ? (event.cumulativeBytesLoaded / event.expectedTotalBytes!) : null;
                    return (CircularProgressIndicator.adaptive(
                      value: progress,
                    ));
                  }, errorBuilder: (BuildContext context, Object object, StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  })))));
}

Widget showErrorScreen(String error) {
  return showTextWithIcon(
      const Icon(
        Icons.error,
        color: Colors.red,
        size: 50.0,
      ),
      error);
}

Widget showTextWithIcon(Icon icon, String text) {
  return Center(
      child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0), child: Column(mainAxisSize: MainAxisSize.min, children: [icon, Text(text)])));
}
