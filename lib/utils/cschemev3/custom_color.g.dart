import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const positive = Color(0xFF54E166);
const negative = Color(0xFFC10015);
const info = Color(0xFF31CCEC);
const warning = Color(0xFFF2C037);
const positive2 = Color(0xFFABD7A6);
const negative2 = Color(0xFFBA5B54);
const warning2 = Color(0xFFEDA561);


CustomColors lightCustomColors = const CustomColors(
  sourcePositive: Color(0xFF54E166),
  positive: Color(0xFF006E21),
  onPositive: Color(0xFFFFFFFF),
  positiveContainer: Color(0xFF72FE7F),
  onPositiveContainer: Color(0xFF002105),
  sourceNegative: Color(0xFFC10015),
  negative: Color(0xFFC00015),
  onNegative: Color(0xFFFFFFFF),
  negativeContainer: Color(0xFFFFDAD6),
  onNegativeContainer: Color(0xFF410002),
  sourceInfo: Color(0xFF31CCEC),
  info: Color(0xFF00687A),
  onInfo: Color(0xFFFFFFFF),
  infoContainer: Color(0xFFACEDFF),
  onInfoContainer: Color(0xFF001F26),
  sourceWarning: Color(0xFFF2C037),
  warning: Color(0xFF775A00),
  onWarning: Color(0xFFFFFFFF),
  warningContainer: Color(0xFFFFDF97),
  onWarningContainer: Color(0xFF251A00),
  sourcePositive2: Color(0xFFABD7A6),
  positive2: Color(0xFF246C2D),
  onPositive2: Color(0xFFFFFFFF),
  positive2Container: Color(0xFFA8F5A5),
  onPositive2Container: Color(0xFF002105),
  sourceNegative2: Color(0xFFBA5B54),
  negative2: Color(0xFF9C413C),
  onNegative2: Color(0xFFFFFFFF),
  negative2Container: Color(0xFFFFDAD6),
  onNegative2Container: Color(0xFF410003),
  sourceWarning2: Color(0xFFEDA561),
  warning2: Color(0xFF8D4F00),
  onWarning2: Color(0xFFFFFFFF),
  warning2Container: Color(0xFFFFDCC0),
  onWarning2Container: Color(0xFF2D1600),
);

CustomColors darkCustomColors = const CustomColors(
  sourcePositive: Color(0xFF54E166),
  positive: Color(0xFF54E166),
  onPositive: Color(0xFF00390D),
  positiveContainer: Color(0xFF005317),
  onPositiveContainer: Color(0xFF72FE7F),
  sourceNegative: Color(0xFFC10015),
  negative: Color(0xFFFFB4AC),
  onNegative: Color(0xFF690006),
  negativeContainer: Color(0xFF93000D),
  onNegativeContainer: Color(0xFFFFDAD6),
  sourceInfo: Color(0xFF31CCEC),
  info: Color(0xFF43D7F8),
  onInfo: Color(0xFF003640),
  infoContainer: Color(0xFF004E5C),
  onInfoContainer: Color(0xFFACEDFF),
  sourceWarning: Color(0xFFF2C037),
  warning: Color(0xFFF2C037),
  onWarning: Color(0xFF3E2E00),
  warningContainer: Color(0xFF5A4400),
  onWarningContainer: Color(0xFFFFDF97),
  sourcePositive2: Color(0xFFABD7A6),
  positive2: Color(0xFF8DD88C),
  onPositive2: Color(0xFF00390D),
  positive2Container: Color(0xFF005317),
  onPositive2Container: Color(0xFFA8F5A5),
  sourceNegative2: Color(0xFFBA5B54),
  negative2: Color(0xFFFFB3AC),
  onNegative2: Color(0xFF5F1413),
  negative2Container: Color(0xFF7E2B27),
  onNegative2Container: Color(0xFFFFDAD6),
  sourceWarning2: Color(0xFFEDA561),
  warning2: Color(0xFFFFB876),
  onWarning2: Color(0xFF4B2800),
  warning2Container: Color(0xFF6B3B00),
  onWarning2Container: Color(0xFFFFDCC0),
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
    required this.sourceInfo,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.sourceWarning,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.sourcePositive2,
    required this.positive2,
    required this.onPositive2,
    required this.positive2Container,
    required this.onPositive2Container,
    required this.sourceNegative2,
    required this.negative2,
    required this.onNegative2,
    required this.negative2Container,
    required this.onNegative2Container,
    required this.sourceWarning2,
    required this.warning2,
    required this.onWarning2,
    required this.warning2Container,
    required this.onWarning2Container,
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
  final Color? sourceInfo;
  final Color? info;
  final Color? onInfo;
  final Color? infoContainer;
  final Color? onInfoContainer;
  final Color? sourceWarning;
  final Color? warning;
  final Color? onWarning;
  final Color? warningContainer;
  final Color? onWarningContainer;
  final Color? sourcePositive2;
  final Color? positive2;
  final Color? onPositive2;
  final Color? positive2Container;
  final Color? onPositive2Container;
  final Color? sourceNegative2;
  final Color? negative2;
  final Color? onNegative2;
  final Color? negative2Container;
  final Color? onNegative2Container;
  final Color? sourceWarning2;
  final Color? warning2;
  final Color? onWarning2;
  final Color? warning2Container;
  final Color? onWarning2Container;

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
    Color? sourceInfo,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? sourceWarning,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? sourcePositive2,
    Color? positive2,
    Color? onPositive2,
    Color? positive2Container,
    Color? onPositive2Container,
    Color? sourceNegative2,
    Color? negative2,
    Color? onNegative2,
    Color? negative2Container,
    Color? onNegative2Container,
    Color? sourceWarning2,
    Color? warning2,
    Color? onWarning2,
    Color? warning2Container,
    Color? onWarning2Container,
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
      sourceInfo: sourceInfo ?? this.sourceInfo,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      sourceWarning: sourceWarning ?? this.sourceWarning,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      sourcePositive2: sourcePositive2 ?? this.sourcePositive2,
      positive2: positive2 ?? this.positive2,
      onPositive2: onPositive2 ?? this.onPositive2,
      positive2Container: positive2Container ?? this.positive2Container,
      onPositive2Container: onPositive2Container ?? this.onPositive2Container,
      sourceNegative2: sourceNegative2 ?? this.sourceNegative2,
      negative2: negative2 ?? this.negative2,
      onNegative2: onNegative2 ?? this.onNegative2,
      negative2Container: negative2Container ?? this.negative2Container,
      onNegative2Container: onNegative2Container ?? this.onNegative2Container,
      sourceWarning2: sourceWarning2 ?? this.sourceWarning2,
      warning2: warning2 ?? this.warning2,
      onWarning2: onWarning2 ?? this.onWarning2,
      warning2Container: warning2Container ?? this.warning2Container,
      onWarning2Container: onWarning2Container ?? this.onWarning2Container,
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
      positiveContainer: Color.lerp(positiveContainer, other.positiveContainer, t),
      onPositiveContainer: Color.lerp(onPositiveContainer, other.onPositiveContainer, t),
      sourceNegative: Color.lerp(sourceNegative, other.sourceNegative, t),
      negative: Color.lerp(negative, other.negative, t),
      onNegative: Color.lerp(onNegative, other.onNegative, t),
      negativeContainer: Color.lerp(negativeContainer, other.negativeContainer, t),
      onNegativeContainer: Color.lerp(onNegativeContainer, other.onNegativeContainer, t),
      sourceInfo: Color.lerp(sourceInfo, other.sourceInfo, t),
      info: Color.lerp(info, other.info, t),
      onInfo: Color.lerp(onInfo, other.onInfo, t),
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t),
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t),
      sourceWarning: Color.lerp(sourceWarning, other.sourceWarning, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t),
      sourcePositive2: Color.lerp(sourcePositive2, other.sourcePositive2, t),
      positive2: Color.lerp(positive2, other.positive2, t),
      onPositive2: Color.lerp(onPositive2, other.onPositive2, t),
      positive2Container: Color.lerp(positive2Container, other.positive2Container, t),
      onPositive2Container: Color.lerp(onPositive2Container, other.onPositive2Container, t),
      sourceNegative2: Color.lerp(sourceNegative2, other.sourceNegative2, t),
      negative2: Color.lerp(negative2, other.negative2, t),
      onNegative2: Color.lerp(onNegative2, other.onNegative2, t),
      negative2Container: Color.lerp(negative2Container, other.negative2Container, t),
      onNegative2Container: Color.lerp(onNegative2Container, other.onNegative2Container, t),
      sourceWarning2: Color.lerp(sourceWarning2, other.sourceWarning2, t),
      warning2: Color.lerp(warning2, other.warning2, t),
      onWarning2: Color.lerp(onWarning2, other.onWarning2, t),
      warning2Container: Color.lerp(warning2Container, other.warning2Container, t),
      onWarning2Container: Color.lerp(onWarning2Container, other.onWarning2Container, t),
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
  ///   * [CustomColors.sourceInfo]
  ///   * [CustomColors.info]
  ///   * [CustomColors.onInfo]
  ///   * [CustomColors.infoContainer]
  ///   * [CustomColors.onInfoContainer]
  ///   * [CustomColors.sourceWarning]
  ///   * [CustomColors.warning]
  ///   * [CustomColors.onWarning]
  ///   * [CustomColors.warningContainer]
  ///   * [CustomColors.onWarningContainer]
  ///   * [CustomColors.sourcePositive2]
  ///   * [CustomColors.positive2]
  ///   * [CustomColors.onPositive2]
  ///   * [CustomColors.positive2Container]
  ///   * [CustomColors.onPositive2Container]
  ///   * [CustomColors.sourceNegative2]
  ///   * [CustomColors.negative2]
  ///   * [CustomColors.onNegative2]
  ///   * [CustomColors.negative2Container]
  ///   * [CustomColors.onNegative2Container]
  ///   * [CustomColors.sourceWarning2]
  ///   * [CustomColors.warning2]
  ///   * [CustomColors.onWarning2]
  ///   * [CustomColors.warning2Container]
  ///   * [CustomColors.onWarning2Container]
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
      sourceInfo: sourceInfo!.harmonizeWith(dynamic.primary),
      info: info!.harmonizeWith(dynamic.primary),
      onInfo: onInfo!.harmonizeWith(dynamic.primary),
      infoContainer: infoContainer!.harmonizeWith(dynamic.primary),
      onInfoContainer: onInfoContainer!.harmonizeWith(dynamic.primary),
      sourceWarning: sourceWarning!.harmonizeWith(dynamic.primary),
      warning: warning!.harmonizeWith(dynamic.primary),
      onWarning: onWarning!.harmonizeWith(dynamic.primary),
      warningContainer: warningContainer!.harmonizeWith(dynamic.primary),
      onWarningContainer: onWarningContainer!.harmonizeWith(dynamic.primary),
      sourcePositive2: sourcePositive2!.harmonizeWith(dynamic.primary),
      positive2: positive2!.harmonizeWith(dynamic.primary),
      onPositive2: onPositive2!.harmonizeWith(dynamic.primary),
      positive2Container: positive2Container!.harmonizeWith(dynamic.primary),
      onPositive2Container: onPositive2Container!.harmonizeWith(dynamic.primary),
      sourceNegative2: sourceNegative2!.harmonizeWith(dynamic.primary),
      negative2: negative2!.harmonizeWith(dynamic.primary),
      onNegative2: onNegative2!.harmonizeWith(dynamic.primary),
      negative2Container: negative2Container!.harmonizeWith(dynamic.primary),
      onNegative2Container: onNegative2Container!.harmonizeWith(dynamic.primary),
      sourceWarning2: sourceWarning2!.harmonizeWith(dynamic.primary),
      warning2: warning2!.harmonizeWith(dynamic.primary),
      onWarning2: onWarning2!.harmonizeWith(dynamic.primary),
      warning2Container: warning2Container!.harmonizeWith(dynamic.primary),
      onWarning2Container: onWarning2Container!.harmonizeWith(dynamic.primary),
    );
  }
}