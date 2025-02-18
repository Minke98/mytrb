import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytrb/utils/colors.dart';

class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color primaryText,
    Color? secondaryText,
    required Color accentColor,
    Color? divider,
    Color? buttonBackground,
    required Color buttonText,
    Color? cardBackground,
    Color? disabled,
    required Color error,
  }) {
    final baseTextTheme = brightness == Brightness.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    return ThemeData(
      brightness: brightness,
      //buttonColor: buttonBackground,
      canvasColor: background,
      cardColor: background,
      dividerColor: divider,
      dividerTheme: DividerThemeData(
        color: divider,
        space: 1,
        thickness: 1,
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      // ignore: deprecated_member_use
      backgroundColor: background,
      primaryColor: accentColor,
      //accentColor: accentColor,
      // textSelectionColor: accentColor,
      // textSelectionHandleColor: accentColor,
      // cursorColor: accentColor,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: accentColor,
        selectionHandleColor: accentColor,
        cursorColor: accentColor,
      ),
      // ignore: deprecated_member_use
      toggleableActiveColor: accentColor,
      appBarTheme: AppBarTheme(
        color: cardBackground,
        iconTheme: IconThemeData(
          color: secondaryText,
        ),
        toolbarTextStyle: ThemeData(brightness: brightness)
            .textTheme
            .copyWith(
              titleLarge: TextStyle(
                  color: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )
            .bodyMedium,
        titleTextStyle: ThemeData(brightness: brightness)
            .textTheme
            .copyWith(
              titleLarge: TextStyle(
                  color: brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )
            .titleLarge,
      ),
      iconTheme: IconThemeData(
        color: secondaryText,
        size: 24.0,
      ),
      // ignore: deprecated_member_use
      errorColor: error,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: accentColor,
          secondary: accentColor,
          surface: background,
          background: background,
          error: error,
          onPrimary: buttonText,
          onSecondary: buttonText,
          onSurface: buttonText,
          onBackground: buttonText,
          onError: buttonText,
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: error),
        labelStyle: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
          color: primaryText.withOpacity(0.5),
        ),
        hintStyle: TextStyle(
          color: secondaryText,
          fontSize: 13.0,
          fontWeight: FontWeight.w300,
        ),
      ),
      fontFamily: 'Rubik',
      unselectedWidgetColor: hexToColor('#DADCDD'),
      textTheme: TextTheme(
        displayLarge: baseTextTheme.displayLarge!.copyWith(
          color: primaryText,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: baseTextTheme.displayMedium!.copyWith(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: baseTextTheme.displaySmall!.copyWith(
          color: secondaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: baseTextTheme.headlineMedium!.copyWith(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: baseTextTheme.headlineSmall!.copyWith(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: baseTextTheme.titleLarge!.copyWith(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseTextTheme.bodyLarge!.copyWith(
          color: secondaryText,
          fontSize: 15,
        ),
        bodyMedium: baseTextTheme.bodyMedium!.copyWith(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: baseTextTheme.labelLarge!.copyWith(
          color: primaryText,
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
        ),
        bodySmall: baseTextTheme.bodySmall!.copyWith(
          color: primaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w300,
        ),
        labelSmall: baseTextTheme.labelSmall!.copyWith(
          color: secondaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: baseTextTheme.titleMedium!.copyWith(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: baseTextTheme.titleSmall!.copyWith(
          color: secondaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
        background: ColorEnvironment.colorPrimaryLight,
        cardBackground: ColorEnvironment.colorContainerLight,
        primaryText: ColorEnvironment.colorTextPrimaryLight,
        secondaryText: ColorEnvironment.colorTextSecondaryLight,
        accentColor: ColorEnvironment.colorContainerLight,
        divider: ColorEnvironment.colorContainerLight,
        buttonBackground: ColorEnvironment.colorIndicatorBackgroundLight,
        buttonText: ColorEnvironment.colorTextLight,
        disabled: ColorEnvironment.lightShadow,
        error: ColorEnvironment.colorError,
      );

  static ThemeData get darkTheme => createTheme(
        brightness: Brightness.dark,
        background: ColorEnvironment.colorPrimaryDark,
        cardBackground: ColorEnvironment.colorContainerDark,
        primaryText: ColorEnvironment.colorTextPrimaryDark,
        secondaryText: ColorEnvironment.colorTextSecondaryDark,
        accentColor: ColorEnvironment.colorContainerDark,
        divider: ColorEnvironment.colorContainerDark,
        buttonBackground: ColorEnvironment.colorIndicatorBackgroundDark,
        buttonText: ColorEnvironment.colorTextDark,
        disabled: ColorEnvironment.darkShadow,
        error: ColorEnvironment.colorError,
      );
}
