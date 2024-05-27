

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email!"),
      ),
      body: Column(
        children: [
          const Text("We've sent you an email verification. Please open it to verify email."),
          const Text("If you haven't recieved a verification email yet, press the button below."),

          TextButton(onPressed: (){
           context.read<AuthBloc>().add(
            const AuthEventSendEmailVerification(),
            );
          }, 
          child: const Text("Send Email verification"),
          ),
          TextButton(onPressed: () {
            context.read<AuthBloc>().add(
            const AuthEventLogOut(),
            );
          }, 
          child: const Text("Restart"),
          ),
        ],
      ),
      );
  }
}