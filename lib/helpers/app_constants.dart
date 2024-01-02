import 'package:flutter/material.dart';

Color whiteColor = Colors.white;
Color mainColor = const Color(0xffE5283C);
Color mainShadeColor = const Color(0xffF25C6D);
Color elevationColor = Colors.black.withOpacity(0.1);
Color greenShadeColor = const Color(0xff4f98a1);
Color greenLightShadeColor = const Color.fromARGB(255, 51, 132, 143);
Color greenSelectedColor = const Color(0xffB12825);

String rupeeSign = '₹';

Size displaySize(BuildContext context) {
  debugPrint('Size = ${MediaQuery.of(context).size}');
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ${displaySize(context).height}');
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint('Width = ${displaySize(context).width}');
  return displaySize(context).width;
}
