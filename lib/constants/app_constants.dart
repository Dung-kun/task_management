import 'package:flutter/cupertino.dart';
import 'package:to_do_list/constants/app_colors.dart';

class AppConstants {
  static const List<BoxShadow> kLogoTextShadow = [
    BoxShadow(
      offset: Offset(0, 4),
      color: AppColors.shadowColor,
      blurRadius: 8,
    ),
    BoxShadow(
      offset: Offset(4, 0),
      color: AppColors.shadowColor,
      blurRadius: 8,
    )
  ];

  static const kLengthSplash = 3;
  static const kAnimationDuration = Duration(milliseconds: 200);
  static const double kDefaultBorderRadius = 5;

}
