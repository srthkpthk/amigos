import 'package:amigos/src/cubits/splashScreen/splash_cubit.dart';
import 'package:amigos/src/ui/splashSection/splash_screen.dart';
import 'package:amigos/src/util/SharedPreferencesHelper.dart';
import 'package:amigos/src/util/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(DevicePreview(
    enabled: false,
    builder: (BuildContext context) => App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amigos',
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeUtils().lightMode,
      darkTheme: ThemeUtils().darkMode,
      home: BlocProvider(
          create: (BuildContext context) =>
              SplashCubit(SharedPreferencesHelper())..checkIfUserIsRegistered(),
          child: SplashScreen()),
    );
  }
}
