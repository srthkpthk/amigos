import 'package:amigos/src/cubits/splashScreen/splash_cubit.dart';
import 'package:amigos/src/ui/splashSection/splash_screen.dart';
import 'package:amigos/src/util/SharedPreferencesHelper.dart';
import 'package:amigos/src/util/theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Amigos',
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
