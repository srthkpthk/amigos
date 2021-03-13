import 'package:amigos/res.dart';
import 'package:amigos/src/cubits/authenticationScreen/authentication_cubit.dart';
import 'package:amigos/src/ui/authenticationScreens/sign_in_screen.dart';
import 'package:amigos/src/ui/homeScreen/home_screen.dart';
import 'package:amigos/src/ui/widgets/entry_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  final _authCubit = AuthenticationCubit();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          elevation: 1,
          title: Text(
            'Sign Up to Amigos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder(
              cubit: _authCubit,
              builder: (BuildContext context, state) =>
                  state is AuthenticationLoading
                      ? Image.asset(Res.small_logo_loading)
                      : Image.asset(Res.small_logo),
            ),
          )),
      body: BlocListener(
        cubit: _authCubit,
        listener: (BuildContext context, state) {
          if (state is AuthenticationError) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
          if (state is AuthenticationSuccessful) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        HomeScreen(state.userEntity)));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(Res.intro_simgle)),
                EntryField.generate('Enter Name', _nameController, true),
                EntryField.generate('Enter Email', _emailController, true),
                EntryField.generate(
                    'Enter Password', _passwordController, false),
                EntryField.generate(
                    'Confirm Password', _confirmPasswordController, false),
                Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: FlatButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => _authCubit.emailSignUp(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _confirmPasswordController.text),
                      child: Text(
                        'Join Amigos',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () => _authCubit.googleSignIn(),
                      child: Text(
                        'Join Amigos via Google',
                      )),
                ),
                FlatButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SignInScreen())),
                    child: Text(
                      'SignIn',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
