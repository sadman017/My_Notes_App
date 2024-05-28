import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';
import 'package:practice_app/Services/auth/bloc/auth_state.dart';
import 'package:practice_app/utilities/dialogs/error_dialog.dart';
import 'package:practice_app/utilities/dialogs/reset_password_email_sent.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
    void initState(){
      _controller = TextEditingController();
      super.initState();
    }
    @override
    void dispose(){
      _controller.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
        if(state is AuthStateForgotPassword){
          if(state.hasSentEmail){
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception !=null){
            await showErrorDialog(context, "You have not registered yet. Please register first.");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reset Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Forgot password? Type your email."),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Type your email..."
                ),
              ),
              TextButton(onPressed: (){
                final email = _controller.text;
                context.read<AuthBloc>().add(AuthEventForgotPassword(
                  email: email,
                ));
              }, child: const Text("Send reset password"),
              ),
              TextButton(onPressed: (){
               
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }, child: const Text("Back to login screen."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}