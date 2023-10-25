import 'package:flutter/material.dart';

class IntValueNotifier extends ValueNotifier {
  IntValueNotifier(super.value);

  void intChange(int) {
    value = int;
  }
}