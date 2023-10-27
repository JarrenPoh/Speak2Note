import 'package:flutter/material.dart';

class VarValueNotifier extends ValueNotifier {
  VarValueNotifier(super.value);

   varChange(e) {
    value = e;
    notifyListeners();
  }
}