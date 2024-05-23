import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';


@immutable
class AuthUser{
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.isEmailVerified,
    required this.email,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
    email: user.email,
    isEmailVerified: user.emailVerified,);
}