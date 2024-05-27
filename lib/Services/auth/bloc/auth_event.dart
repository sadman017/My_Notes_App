import 'package:flutter/foundation.dart';

@immutable
class AuthEvent{
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent{
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;

  const AuthEventLogIn({required this.email, required this.password});
}

class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;

  const AuthEventRegister( this.email, this.password);
}

class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}

class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}