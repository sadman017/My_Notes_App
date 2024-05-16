import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          const Text("Please Verify Email"),
          TextButton(onPressed: ()async{
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
            if(user != null){
            if(user.emailVerified){
            Navigator.of(context).pushNamedAndRemoveUntil(
            '/notes/', 
            (route) => false,
            );
            }
            }
          }, 
          child: const Text("Send Email verification"),
          )
        ],
      ),
      );
  }
}