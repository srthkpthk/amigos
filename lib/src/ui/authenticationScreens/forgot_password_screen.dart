import 'package:amigos/src/cubits/authenticationScreen/authentication_cubit.dart';
import 'package:amigos/src/ui/widgets/entry_filed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../res.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _authCubit = AuthenticationCubit();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          elevation: 1,
          title: Text(
            'Forgot Password',
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
          if (state is PasswordLinkSent) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(Res.intro_simgle)),
                EntryField.generate('Enter Email', _emailController, true),
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
                      onPressed: () => _authCubit
                          .sendChangePasswordLink(_emailController.text),
                      child: Text(
                        'Login Amigos',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
