import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ThemeUtils {
  get lightMode => ThemeData(
              brightness: Brightness.light,
              accentColor: Color(0xFF061932),
              primaryColor: Colors.white)
          .copyWith(
              pageTransitionsTheme: PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                transitionType: SharedAxisTransitionType.vertical),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder()
          }));

  get darkMode => ThemeData(
              brightness: Brightness.dark,
              accentColor: Color(0xFF5271ff),
              primaryColor: Colors.black)
          .copyWith(
              pageTransitionsTheme: PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder()
          }));
}
