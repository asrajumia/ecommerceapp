import 'package:flutter/material.dart';

InputDecoration textfileStyle(String labelText) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),
    labelText: labelText,
    filled: true,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );
}
