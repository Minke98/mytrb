import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorEnvironment {
  static bool get isDarkMode => Get.isDarkMode;
  static const Color colorPrimaryLight = Color.fromRGBO(235, 240, 243, 1);
  static const Color colorPrimaryDark = Color.fromRGBO(32, 35, 41, 1);

  static Color colorPrimaryWhite = const Color(0xFFCADCED);
  static Color mainBlur = const Color.fromRGBO(216, 126, 43, 1);

  static const Color colorContainerLight = Color.fromRGBO(241, 245, 248, 1);
  static const Color colorContainerDark = Color.fromRGBO(40, 50, 54, 1);

  static const Color colorContainerPressedLight =
      Color.fromRGBO(232, 235, 241, 1);
  static const Color colorContainerPressedDark = Color.fromRGBO(45, 50, 54, 1);

  static const Color colorContainerShadowTopLight =
      Color.fromARGB(220, 255, 255, 255);
  static const Color colorContainerShadowTopDark =
      Color.fromRGBO(255, 255, 255, 0.1);

  static const Color colorContainerShadowBottomLight =
      Color.fromARGB(18, 0, 0, 0);
  static const Color colorContainerShadowBottomDark =
      Color.fromRGBO(0, 0, 0, .3);

  static const Color colorContainerInnerShadowTopLight =
      Color.fromRGBO(204, 206, 212, 1);
  static const Color colorContainerInnerShadowTopDark =
      Color.fromRGBO(0, 0, 0, .9);

  static const Color colorContainerInnerShadowBottomLight =
      Color.fromRGBO(255, 255, 255, 1);
  static const Color colorContainerInnerShadowBottomDark =
      Color.fromRGBO(49, 54, 60, 1);

  static const Color colorTextLight = Color.fromRGBO(144, 149, 166, 1);
  static const Color colorTextDark = Color.fromRGBO(137, 142, 158, 1);

  static const Color colorTextPrimaryLight = Color.fromRGBO(53, 54, 59, 1);
  static const Color colorTextPrimaryDark = Color.fromRGBO(255, 255, 255, 1);

  static const Color colorTextSecondaryLight = Color.fromRGBO(144, 149, 166, 1);
  static const Color colorTextSecondaryDark = Color.fromRGBO(139, 144, 160, 1);

  static const Color colorIconLight = Color.fromRGBO(144, 149, 166, 1);
  static const Color colorIconDark = Color.fromRGBO(137, 142, 158, 1);

  static Color colorButton = const Color(0xFF005C97);
  static Color colorContrast = const Color(0xFF0295f2);
  static Color colorTextButton = const Color(0xFFFFFFFF);

  static const Color colorIndicatorBackgroundLight =
      Color.fromRGBO(255, 255, 255, 1);
  static const Color colorIndicatorBackgroundDark = colorContainerDark;

  static const darkShadow = Color(0xffcfceca);
  static const darkModeShadow = Color(0xff0e0f0f);
  static const lightShadow = Color(0xffffffff);
  static const lightModeShadow = Color(0xff373838);

  static const onlineIndicator = Color(0xff0ee50a);

  static const colorBlue1 = Color(0xFF005C97);
  static const colorBlue2 = Color(0xFF1046B3);
  static const colorBlue3 = Color(0xFF3383CD);
  static const colorBlue4 = Color(0xFF306EFF);
  static const colorBlue5 = Color(0xFF3382CC);
  static const colorBlue6 = Color(0xFF4985FD);
  static const colorBlue7 = Color(0xFF00AED6);
  static const colorDarkBlue1 = Color(0xFF03266b);
  static const colorDarkBlue2 = Color(0xFF0e234d);

  static const colorYellow1 = Color(0xffe8b638);
  static const colorYellow2 = Color(0xfffdcc3b);
  static const kInfectedColor = Color(0xFFFF8748);

  static const colorGreen1 = Color(0xFF009D57);
  static const colorGreen2 = Color(0xFF36C12C);

  static const colorRed1 = Color(0xFFD71149);
  static const colorRed2 = Color(0xFFD23C3C);
  static const colorRed3 = Color(0xFFFF4848);

  static const colorWhite1 = Color(0xFFFFFFFF);
  static const colorWhite2 = Color(0xFFFEFEFE);
  static const colorWhite3 = Color(0xFFF5F5F5);
  static const colorWhite4 = Color(0xFFD5E9F4);
  static const colorWhite5 = Color(0xFFE0E0E0);
  static const colorWhite6 = Color(0xFFF4F5F7);
  static const colorWhite7 = Color(0xFFF9EFD0);

  static const colorBlack1 = Color(0xFF2D3243);

  static const colorGrey1 = Color(0xFF303030);
  static const colorGrey2 = Color(0xFF4B4B4B);
  static const colorGrey3 = Color(0xFF959595);
  static Color colorGrey4 = const Color(0xFFB7B7B7).withOpacity(.16);

  static var gradientBlackOpacity = [
    const Color(0xFF000000).withOpacity(0.1),
    const Color(0xFF000000).withOpacity(0.7)
  ];
  static const gradientBlue1 = [Color(0xFF005C97), Color(0xFF363795)];
  static const gradientBlue2 = [Color(0xFF3383CD), Color(0xFF11249F)];
  static const gradientBlue3 = [Color(0xFF00AADE), Color(0xFF0669B1)];
  static var gradientBlue4 = [
    const Color(0xFF00AADE),
    const Color(0xFF0669B1).withOpacity(0.8)
  ];
  static const gradientGreen = [Color(0xFF0ad178), Color(0xFF009D57)];

  static const colorSecondaryLight = Color(0xFFE3EDF7);
  static const colorSecondaryDark = Color.fromRGBO(28, 31, 36, 1);
  static const colorAccent = colorBlue4;

  static const colorHeadingDark = colorBlue1;
  static const colorHeadingLight = colorWhite1;
  static const colorTitleDark = colorGrey1;
  static const colorTitleLight = colorWhite2;
  static Color colorInfo = Color(Colors.blueAccent[200]!.value);
  static Color colorWarning = Color(Colors.amberAccent[200]!.value);
  static Color colorDanger = Color(Colors.pinkAccent[200]!.value);
  static Color colorSuccess = Color(Colors.greenAccent[400]!.value);
  static Color colorError = Color(Colors.redAccent[400]!.value);

  static Color get colorIcon => isDarkMode ? colorContrast : colorButton;

  static var softShadows = [
    BoxShadow(
        color: colorShadowBottom,
        offset: const Offset(2.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0),
    BoxShadow(
        color: colorShadowTop,
        offset: const Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 1.0),
  ];

  static var softShadowsInvert = [
    const BoxShadow(
        color: lightShadow,
        offset: Offset(2.0, 2.0),
        blurRadius: 2.0,
        spreadRadius: 2.0),
    const BoxShadow(
        color: darkShadow,
        offset: Offset(-2.0, -2.0),
        blurRadius: 2.0,
        spreadRadius: 2.0),
  ];

  static Color get colorBackground =>
      isDarkMode ? colorPrimaryDark : colorPrimaryLight;
  static Color get colorPrimary =>
      isDarkMode ? colorPrimaryDark : colorPrimaryLight;
  static Color get primaryWhite =>
      isDarkMode ? colorPrimaryDark : colorPrimaryWhite;
  static Color get colorSecondary =>
      isDarkMode ? colorSecondaryDark : colorSecondaryLight;
  static Color get colorBlueIcon => isDarkMode ? colorBlue5 : colorButton;

  static Color get colorContainer =>
      isDarkMode ? colorContainerDark : colorContainerLight;

  static Color get colorContainerPressed =>
      isDarkMode ? colorContainerPressedDark : colorContainerPressedLight;

  static Color get colorContainerShadowTop =>
      isDarkMode ? colorContainerShadowTopDark : colorContainerShadowTopLight;

  static Color get colorContainerShadowBottom => isDarkMode
      ? colorContainerShadowBottomDark
      : colorContainerShadowBottomLight;

  static Color get colorShadowTop => isDarkMode ? lightModeShadow : lightShadow;
  static Color get colorShadowBottom =>
      isDarkMode ? darkModeShadow : darkShadow;

  static Color get colorContainerInnerShadowTop => isDarkMode
      ? colorContainerInnerShadowTopDark
      : colorContainerInnerShadowTopLight;

  static Color get colorContainerInnerShadowBottom => isDarkMode
      ? colorContainerInnerShadowBottomDark
      : colorContainerInnerShadowBottomLight;

  static Color get colorText => isDarkMode ? colorTextDark : colorTextLight;

  static Color get colorTextPrimary =>
      isDarkMode ? colorTextPrimaryDark : colorTextPrimaryLight;

  static Color get colorTextSecondary =>
      isDarkMode ? colorTextSecondaryDark : colorTextSecondaryLight;

  static Color get colorIndicatorBackground =>
      isDarkMode ? colorIndicatorBackgroundDark : colorIndicatorBackgroundLight;
  static Color get colorGray =>
      isDarkMode ? Colors.black12.withOpacity(0.5) : colorWhite4;
  // Card Color
  static const cardDarkModeShadowBottom = Color(0xff3158a8);
  static const cardDarkModeShadowTop = Color(0xff0c1a38);
  static Color get cardPrimaryBackground =>
      isDarkMode ? colorDarkBlue1 : colorPrimaryWhite;
  static Color get cardColorCircle => isDarkMode ? colorDarkBlue2 : colorWhite4;
  static Color get cardShadowBottom =>
      isDarkMode ? cardDarkModeShadowBottom : lightShadow;
  static Color get cardShadowTop =>
      isDarkMode ? cardDarkModeShadowTop : darkShadow;
  // Card Color
  static final colorActions = <String, Color>{
    "view": colorInfo,
    "edit": colorWarning,
    "delete": colorDanger,
  };

  static final attendanceColors = <String, Color>{
    'attendance': colorInfo,
    'default': colorInfo,
    'overtime': colorSuccess,
    'switch': colorWarning,
    'sick': colorError,
    'permit': colorError,
    'leave': colorError,
    'absent': colorError,
    'holiday': colorError,
  };

  static final statusColors = <String, Color>{
    'active': colorInfo,
    'inactive': colorInfo,
    'open': colorInfo,
    'closed': colorGrey3,
    'draft': colorIcon,
    'approved': colorSuccess,
    'rejected': colorError,
    'submit': colorWarning,
    'pending': colorWarning,
    'cancelled': colorDanger,
  };

  static final approvalActions = {
    "submit": const Color(0xFF3383CD),
    "popup": const Color(0xFFFF4848),
  };
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
