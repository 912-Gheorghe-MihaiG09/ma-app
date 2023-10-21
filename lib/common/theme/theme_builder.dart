import 'package:crud_project/common/theme/colors.dart';
import 'package:crud_project/common/theme/theme_attributes.dart';
import 'package:flutter/material.dart';

class ThemeBuilder extends ChangeNotifier {
  ThemeBuilder();

  static ThemeData getThemeData() {
    var attr = ThemeAttributes();
    return ThemeData(
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
          error: AppColors.error),
      brightness: Brightness.light,
      elevatedButtonTheme: attr.elevatedButtonThemeData,
      inputDecorationTheme: attr.inputDecorationTheme,
      textTheme: attr.textTheme,
      appBarTheme: attr.appBarTheme,
      textButtonTheme: attr.textButtonThemeData,
      scaffoldBackgroundColor:AppColors.surface,
    );
  }
}
