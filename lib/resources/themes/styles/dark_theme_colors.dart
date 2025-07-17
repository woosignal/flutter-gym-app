import 'package:flutter/material.dart';
import '/resources/themes/styles/color_styles.dart';

/* Dark Theme Colors
|-------------------------------------------------------------------------- */

class DarkThemeColors implements ColorStyles {
  // general
  @override
  Color get background => const Color(0xff161c20);

  @override
  Color get content => const Color(0xFFE1E1E1);
  @override
  Color get primaryAccent => const Color(0xffa0baff);

  @override
  Color get surfaceBackground => Colors.white70;
  @override
  Color get surfaceContent => Colors.black;

  // app bar
  @override
  Color get appBarBackground => const Color(0xff2a343c);
  @override
  Color get appBarPrimaryContent => Colors.white;

  // buttons
  @override
  Color get buttonBackground => const Color(0xffd8d8d8);
  @override
  Color get buttonContent => Colors.black87;

  @override
  Color get buttonSecondaryBackground => Colors.grey.shade800;
  @override
  Color get buttonSecondaryContent => Colors.white70;

  // bottom tab bar
  @override
  Color get bottomTabBarBackground => const Color(0xFF232c33);

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected => Colors.white70;
  @override
  Color get bottomTabBarIconUnselected => Colors.white60;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected => Colors.white54;
  @override
  Color get bottomTabBarLabelSelected => Colors.white;

  // toast notification
  @override
  Color get toastNotificationBackground => const Color(0xff3e4447);
}
