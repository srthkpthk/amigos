part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class AuthenticatedUser extends SplashState {
  final UserEntity userEntity;

  AuthenticatedUser(this.userEntity);
}

class UnAuthenticatedUser extends SplashState {}

class InternetNotAvailable extends SplashState {}
