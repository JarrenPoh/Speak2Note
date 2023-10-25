import 'package:flutter/material.dart';

class MapValueNotifier extends ValueNotifier {
  MapValueNotifier(super.value);

  void mapChange(body, bool done, String query) {
    value = {
      "body": body,
      "done": done,
      "query": query,
    };
  }
}
