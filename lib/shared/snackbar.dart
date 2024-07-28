import 'package:flutter/material.dart';

 showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // duraation of display snack bar (notification)
      duration: const Duration(days: 1),
      content: Text(text),
      // when press on close , the snack bar will disappear
      action: SnackBarAction(label: "close", onPressed: () {}),
    ));
 }