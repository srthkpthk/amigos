part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccessful extends AuthenticationState {
  final UserEntity userEntity;

  AuthenticationSuccessful(this.userEntity);
}

class AuthenticationError extends AuthenticationState {
  final String errorMessage;

  AuthenticationError(this.errorMessage);
}

class AuthenticationLoading extends AuthenticationState {}

class PasswordLinkSent extends AuthenticationState {}
