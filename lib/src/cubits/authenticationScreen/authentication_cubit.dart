import 'dart:math';

import 'package:amigos/src/model/userModel/UserEntity.dart';
import 'package:amigos/src/util/SharedPreferencesHelper.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _sharedPreferencesHelper = SharedPreferencesHelper();
  final CollectionReference _collectionReference =
      Firestore.instance.collection('Users');

  googleSignIn() async {
    try {
      emit(AuthenticationLoading());
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      _sharedPreferencesHelper.saveUid(user.uid);

      if (await _collectionReference
          .document(user.uid)
          .get()
          .then((value) => value.exists)) {
        emit(AuthenticationSuccessful(UserEntity.fromJsonMap(
            await _collectionReference
                .document(user.uid)
                .get()
                .then((value) => value.data))));
      } else {
        final _user = UserEntity(
            'New User',
            DateTime.now().subtract(Duration(days: 100)).toString(),
            user.email,
            await FirebaseMessaging().getToken(),
            0,
            0,
            [],
            [],
            user.uid,
            false,
            DateTime.now().toString(),
            'Earth',
            user.displayName,
            user.photoUrl,
            '${user.displayName.replaceAll(' ', '').toLowerCase()}${Random().nextInt(100)}');
        _collectionReference.document(user.uid).setData(_user.toJson());
        emit(AuthenticationSuccessful(_user));
      }
    } on NoSuchMethodError {
      emit(AuthenticationError('Google Authentication Failed Please Retry'));
    } catch (e) {
      emit(AuthenticationError(AuthExceptionHandler.generateExceptionMessage(
          AuthExceptionHandler.handleException(e))));
    }
  }

  emailSignUp(String email, String password, String name,
      String confirmPassword) async {
    if (validateEmailAndPassword(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        name: name)) {
      try {
        emit(AuthenticationLoading());
        AuthResult _user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        _sharedPreferencesHelper.saveUid(_user.user.uid);
        _collectionReference.document(_user.user.uid).setData(UserEntity(
                'New User',
                DateTime.now().subtract(Duration(days: 100)).toString(),
                email,
                await FirebaseMessaging().getToken(),
                0,
                0,
                [],
                [],
                _user.user.uid,
                false,
                DateTime.now().toString(),
                'Earth',
                name,
                'https://firebasestorage.googleapis.com/v0/b/amigos-srthk.appspot.com/o/Commons%2FAm.png?alt=media&token=352d57e5-b88d-40f9-a28f-2cff26f43bba',
                '${name.replaceAll(' ', '').toLowerCase()}${Random().nextInt(100)}')
            .toJson());
      } catch (e) {
        emit(AuthenticationError(AuthExceptionHandler.generateExceptionMessage(
            AuthExceptionHandler.handleException(e))));
      }
    }
  }

  sendChangePasswordLink(String email) async {
    try {
      emit(AuthenticationLoading());
      _auth.sendPasswordResetEmail(email: email);
      emit(PasswordLinkSent());
    } catch (e) {
      emit(AuthenticationError(AuthExceptionHandler.generateExceptionMessage(
          AuthExceptionHandler.handleException(e))));
    }
  }

  bool validateEmailAndPassword(
      {String email, String password, String confirmPassword, String name}) {
    if (email.isEmpty) {
      emit(AuthenticationError('Email is Empty'));
      return false;
    }
    if (password.isEmpty) {
      emit(AuthenticationError('Password is Empty'));
      return false;
    }
    if (confirmPassword.isEmpty) {
      emit(AuthenticationError('Confirm Password is Empty'));
      return false;
    }
    if (name.isEmpty) {
      emit(AuthenticationError('Name can\'t be empty'));
      return false;
    }
    if (password.length < 6) {
      emit(AuthenticationError('Password be at least 6 digits'));
    }
    if (password != confirmPassword) {
      emit(AuthenticationError('Password and Confirm Password don\'t match'));
      return false;
    }
    return true;
  }

  emailSignIn(String email, String password) async {
    if (validateEmailAndPassword(email: email, password: password)) {
      try {
        emit(AuthenticationLoading());
        AuthResult _user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        _sharedPreferencesHelper.saveUid(_user.user.uid);
        emit(AuthenticationSuccessful(UserEntity.fromJsonMap(
            await _collectionReference
                .document(_user.user.uid)
                .get()
                .then((value) => value.data))));
      } catch (e) {
        emit(AuthenticationError(AuthExceptionHandler.generateExceptionMessage(
            AuthExceptionHandler.handleException(e))));
      }
    }
  }
}

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}
