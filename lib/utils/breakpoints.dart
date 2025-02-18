// import 'package:flutter/material.dart';

enum DeviceSize { xsmall, small, medium, large }

extension DeviceSizeX on DeviceSize {
  bool get isXsmall => this == DeviceSize.xsmall;
  bool get isSmall => this == DeviceSize.small;
  bool get isMedium => this == DeviceSize.medium;
  bool get isLarge => this == DeviceSize.large;
}

class Breakpoints {
  DeviceSize device = DeviceSize.small;
  var wdth = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  final smallLayout;
  // ignore: prefer_typing_uninitialized_variables
  final mediumLayout;
  // ignore: prefer_typing_uninitialized_variables
  final largeLayout;
  Breakpoints({this.smallLayout, this.largeLayout, this.mediumLayout});
  // static type(width) {
  //   if (width <= 640) {
  //     dsize = DeviceSize.small;
  //   } else if (width <= 768) {
  //     dsize = DeviceSize.medium;
  //   } else {
  //     dsize = DeviceSize.large;
  //   }
  //   return dsize;
  // }

  set width(width) {
    wdth = width;
    if (width <= 599.99) {
      device = DeviceSize.small;
    } else if (width <= 1023.99) {
      device = DeviceSize.medium;
    } else {
      device = DeviceSize.large;
    }
    // large > 1919.99
  }

  get type {
    return device;
  }

  get render {
    if (device.isSmall) {
      return smallLayout;
    } else if (device.isMedium) {
      return mediumLayout ?? smallLayout;
    } else {
      return largeLayout ?? mediumLayout ?? smallLayout;
    }
  }
}
