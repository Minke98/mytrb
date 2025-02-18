import 'package:flutter/material.dart';

class MyDialog {
  static bool isAnyOpen(BuildContext ctx) {
    // log("is dialog ${ModalRoute.of(ctx)?.isCurrent != false}");
    return ModalRoute.of(ctx)?.isCurrent != true;
  }
}
