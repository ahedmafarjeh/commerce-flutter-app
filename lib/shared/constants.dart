import 'package:flutter/material.dart';

const myTextFieldDecoration = InputDecoration(
  hintText: "Enter Your Email : ",
  // To delete borders
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide.none,
  ),

  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.blue,
    ),
  ),
  // fillColor: Colors.red,
  filled: true,
  contentPadding: EdgeInsets.all(8),
);
