import 'package:flutter/widgets.dart';

class ResponsiveHelpers {
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 640;
  }

  static double getContentWidth(BuildContext context, {double factor = 0.5}) {
    final width = MediaQuery.of(context).size.width;
    return isTablet(context) ? width * factor : width;
  }

  static double getButtonWidth(BuildContext context, {
    double tabletFactor = 0.5,
    double mobileFactor = 0.9,
  }) {
    final width = MediaQuery.of(context).size.width;
    return isTablet(context) 
        ? width * tabletFactor 
        : width * mobileFactor;
  }
}
