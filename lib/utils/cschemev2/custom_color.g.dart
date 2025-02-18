import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const positive = Color(0xFF21BA45);
const negative = Color(0xFFC10015);
const warning = Color(0xFFF2C037);
const info = Color(0xFF31CCEC);

CustomColors lightCustomColors = const CustomColors(
  sourcePositive: Color(0xFF21BA45),
  positive: Color(0xFF006E22),
  onPositive: Color(0xFFFFFFFF),
  positiveContainer: Color(0xFF72FE7F),
  onPositiveContainer: Color(0xFF002105),
  sourceNegative: Color(0xFFC10015),
  negative: Color(0xFFC00015),
  onNegative: Color(0xFFFFFFFF),
  negativeContainer: Color(0xFFFFDAD6),
  onNegativeContainer: Color(0xFF410002),
  sourceWarning: Color(0xFFF2C037),
  warning: Color(0xFF775A00),
  onWarning: Color(0xFFFFFFFF),
  warningContainer: Color(0xFFFFDF97),
  onWarningContainer: Color(0xFF251A00),
  sourceInfo: Color(0xFF31CCEC),
  info: Color(0xFF00687A),
  onInfo: Color(0xFFFFFFFF),
  infoContainer: Color(0xFFACEDFF),
  onInfoContainer: Color(0xFF001F26),
);

CustomColors darkCustomColors = const CustomColors(
  sourcePositive: Color(0xFF21BA45),
  positive: Color(0xFF54E166),
  onPositive: Color(0xFF00390D),
  positiveContainer: Color(0xFF005317),
  onPositiveContainer: Color(0xFF72FE7F),
  sourceNegative: Color(0xFFC10015),
  negative: Color(0xFFFFB4AC),
  onNegative: Color(0xFF690006),
  negativeContainer: Color(0xFF93000D),
  onNegativeContainer: Color(0xFFFFDAD6),
  sourceWarning: Color(0xFFF2C037),
  warning: Color(0xFFF2C037),
  onWarning: Color(0xFF3E2E00),
  warningContainer: Color(0xFF5A4400),
  onWarningContainer: Color(0xFFFFDF97),
  sourceInfo: Color(0xFF31CCEC),
  info: Color(0xFF43D7F8),
  onInfo: Color(0xFF003640),
  infoContainer: Color(0xFF004E5C),
  onInfoContainer: Color(0xFFACEDFF),
);

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourcePositive,
    required this.positive,
    required this.onPositive,
    required this.positiveContainer,
    required this.onPositiveContainer,
    required this.sourceNegative,
    required this.negative,
    required this.onNegative,
    required this.negativeContainer,
    required this.onNegativeContainer,
    required this.sourceWarning,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.sourceInfo,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  final Color? sourcePositive;
  final Color? positive;
  final Color? onPositive;
  final Color? positiveContainer;
  final Color? onPositiveContainer;
  final Color? sourceNegative;
  final Color? negative;
  final Color? onNegative;
  final Color? negativeContainer;
  final Color? onNegativeContainer;
  final Color? sourceWarning;
  final Color? warning;
  final Color? onWarning;
  final Color? warningContainer;
  final Color? onWarningContainer;
  final Color? sourceInfo;
  final Color? info;
  final Color? onInfo;
  final Color? infoContainer;
  final Color? onInfoContainer;

  @override
  CustomColors copyWith({
    Color? sourcePositive,
    Color? positive,
    Color? onPositive,
    Color? positiveContainer,
    Color? onPositiveContainer,
    Color? sourceNegative,
    Color? negative,
    Color? onNegative,
    Color? negativeContainer,
    Color? onNegativeContainer,
    Color? sourceWarning,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? sourceInfo,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return CustomColors(
      sourcePositive: sourcePositive ?? this.sourcePositive,
      positive: positive ?? this.positive,
      onPositive: onPositive ?? this.onPositive,
      positiveContainer: positiveContainer ?? this.positiveContainer,
      onPositiveContainer: onPositiveContainer ?? this.onPositiveContainer,
      sourceNegative: sourceNegative ?? this.sourceNegative,
      negative: negative ?? this.negative,
      onNegative: onNegative ?? this.onNegative,
      negativeContainer: negativeContainer ?? this.negativeContainer,
      onNegativeContainer: onNegativeContainer ?? this.onNegativeContainer,
      sourceWarning: sourceWarning ?? this.sourceWarning,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      sourceInfo: sourceInfo ?? this.sourceInfo,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourcePositive: Color.lerp(sourcePositive, other.sourcePositive, t),
      positive: Color.lerp(positive, other.positive, t),
      onPositive: Color.lerp(onPositive, other.onPositive, t),
      positiveContainer:
          Color.lerp(positiveContainer, other.positiveContainer, t),
      onPositiveContainer:
          Color.lerp(onPositiveContainer, other.onPositiveContainer, t),
      sourceNegative: Color.lerp(sourceNegative, other.sourceNegative, t),
      negative: Color.lerp(negative, other.negative, t),
      onNegative: Color.lerp(onNegative, other.onNegative, t),
      negativeContainer:
          Color.lerp(negativeContainer, other.negativeContainer, t),
      onNegativeContainer:
          Color.lerp(onNegativeContainer, other.onNegativeContainer, t),
      sourceWarning: Color.lerp(sourceWarning, other.sourceWarning, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t),
      sourceInfo: Color.lerp(sourceInfo, other.sourceInfo, t),
      info: Color.lerp(info, other.info, t),
      onInfo: Color.lerp(onInfo, other.onInfo, t),
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t),
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [CustomColors.sourcePositive]
  ///   * [CustomColors.positive]
  ///   * [CustomColors.onPositive]
  ///   * [CustomColors.positiveContainer]
  ///   * [CustomColors.onPositiveContainer]
  ///   * [CustomColors.sourceNegative]
  ///   * [CustomColors.negative]
  ///   * [CustomColors.onNegative]
  ///   * [CustomColors.negativeContainer]
  ///   * [CustomColors.onNegativeContainer]
  ///   * [CustomColors.sourceWarning]
  ///   * [CustomColors.warning]
  ///   * [CustomColors.onWarning]
  ///   * [CustomColors.warningContainer]
  ///   * [CustomColors.onWarningContainer]
  ///   * [CustomColors.sourceInfo]
  ///   * [CustomColors.info]
  ///   * [CustomColors.onInfo]
  ///   * [CustomColors.infoContainer]
  ///   * [CustomColors.onInfoContainer]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      sourcePositive: sourcePositive!.harmonizeWith(dynamic.primary),
      positive: positive!.harmonizeWith(dynamic.primary),
      onPositive: onPositive!.harmonizeWith(dynamic.primary),
      positiveContainer: positiveContainer!.harmonizeWith(dynamic.primary),
      onPositiveContainer: onPositiveContainer!.harmonizeWith(dynamic.primary),
      sourceNegative: sourceNegative!.harmonizeWith(dynamic.primary),
      negative: negative!.harmonizeWith(dynamic.primary),
      onNegative: onNegative!.harmonizeWith(dynamic.primary),
      negativeContainer: negativeContainer!.harmonizeWith(dynamic.primary),
      onNegativeContainer: onNegativeContainer!.harmonizeWith(dynamic.primary),
      sourceWarning: sourceWarning!.harmonizeWith(dynamic.primary),
      warning: warning!.harmonizeWith(dynamic.primary),
      onWarning: onWarning!.harmonizeWith(dynamic.primary),
      warningContainer: warningContainer!.harmonizeWith(dynamic.primary),
      onWarningContainer: onWarningContainer!.harmonizeWith(dynamic.primary),
      sourceInfo: sourceInfo!.harmonizeWith(dynamic.primary),
      info: info!.harmonizeWith(dynamic.primary),
      onInfo: onInfo!.harmonizeWith(dynamic.primary),
      infoContainer: infoContainer!.harmonizeWith(dynamic.primary),
      onInfoContainer: onInfoContainer!.harmonizeWith(dynamic.primary),
    );
  }
}
