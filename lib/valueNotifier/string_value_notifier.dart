import 'package:flutter/material.dart';

class VarValueNotifier extends ValueNotifier {
  VarValueNotifier(super.value);

  void varChange(e) {
    value = e;
  }
}