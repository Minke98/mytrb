// utils/device_utils.dart

import 'package:flutter/material.dart';

class DeviceUtils {
  static double getDeviceMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
