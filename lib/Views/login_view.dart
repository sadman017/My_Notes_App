
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/Services/auth/auth_exception.dart';
import 'package:practice_app/Services/auth/bloc/auth_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
   late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
        ),
   
      body :Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Enter email",
                      ),
                   ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: "Enter Password",
                      ),
          
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try{
                          context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email: email, 
                              password: password,
                              ),
                          );
                        } on UserNotFoundAuthException {
                           await showErrorDialog(
                            context, 
                            "User not found",
                           );
                        } on WrongPasswordAuthException{
                          await showErrorDialog(
                            context, 
                            "Wrong-Password",
                            );
                        } on GenericAuthException{
                          await showErrorDialog(
                            context, 
                            "Authentication error",
                          );
                        }
                      }, 
                      child: const Text("Login"),
                      ),
                      TextButton(onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, 
                        (route) => false,
                        );
                      }, 
                      child: const Text("Not registered yet? Register now!"),),
                   ],
          ),
          );
  }
}

