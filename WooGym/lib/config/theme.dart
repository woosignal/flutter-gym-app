import '/resources/themes/dark_theme.dart';
import '/resources/themes/light_theme.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/styles/dark_theme_colors.dart';
import '/resources/themes/styles/light_theme_colors.dart';
import 'package:nylo_framework/nylo_framework.dart';

/*
|--------------------------------------------------------------------------
| Theme Config
|--------------------------------------------------------------------------
*/

// App Themes
final List<BaseThemeConfig<ColorStyles>> appThemes = [
  BaseThemeConfig<ColorStyles>(
    id: getEnv('LIGHT_THEME_ID'),
    description: "Light theme",
    theme: lightTheme,
    colors: LightThemeColors(),
  ),
  BaseThemeConfig<ColorStyles>(
    id: getEnv('DARK_THEME_ID'),
    description: "Dark theme",
    theme: darkTheme,
    colors: DarkThemeColors(),
  ),
];

/*
|--------------------------------------------------------------------------
| Theme Colors
|--------------------------------------------------------------------------
*/

// Light Colors
ColorStyles lightColors = LightThemeColors();

// Dark Colors
ColorStyles darkColors = DarkThemeColors();
