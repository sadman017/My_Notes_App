import 'package:flutter/foundation.dart';

@immutable
class AuthEvent{
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;

  const AuthEventLogIn({required this.email, required this.password});
}

class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}