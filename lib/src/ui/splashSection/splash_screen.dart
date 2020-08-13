import 'package:amigos/res.dart';
import 'package:amigos/src/cubits/splashScreen/splash_cubit.dart';
import 'package:amigos/src/ui/authenticationScreens/sign_up_screen.dart';
import 'package:amigos/src/ui/homeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF061932),
      body: BlocListener(
        cubit: context.bloc<SplashCubit>(),
        listener: (BuildContext context, state) {
          if (state is UnAuthenticatedUser) {
            Future.delayed(
                Duration(seconds: 2),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SignUpScreen())));
          }
          if (state is AuthenticatedUser) {
            Future.delayed(
                Duration(seconds: 2),
                () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeScreen(state.userEntity))));
          }
          if (state is InternetNotAvailable) {
            Future.delayed(Duration(seconds: 2), () {
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Please Check for any Internet Issues')));
//              context.bloc<SplashCubit>().emit(UnAuthenticatedUser());
            });
          }
        },
        child: Center(child: Image.asset(Res.splash)),
      ),
    );
  }
}
