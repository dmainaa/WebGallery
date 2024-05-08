import 'package:flutter/material.dart';
class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? laptop;

  const ResponsiveWidget({Key? key, this.mobile, this.tablet, this.desktop, this.laptop}) : super(key: key);

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 700;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1200 && MediaQuery.of(context).size.width >= 700;

  static bool isLaptop(BuildContext context) => MediaQuery.of(context).size.width < 1580 && MediaQuery.of(context).size.width >= 1200;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1580;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // If our width is more than 1450 then we consider it a desktop
    if (size.width >= 1580) {
      return desktop!;
    } else if (size.width >= 1200 && size.width <= 1580) {
      return laptop!;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (size.width >= 700 && size.width <= 1200) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile!;
    }
  }
}