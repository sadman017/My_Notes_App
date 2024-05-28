import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';
import 'package:practice_app/Services/auth/bloc/auth_state.dart';
import 'package:practice_app/Services/auth/firebase_auth_provider.dart';
import 'package:practice_app/Views/forgot_password_view.dart';
import 'package:practice_app/Views/login_view.dart';
import 'package:practice_app/Views/notes/create_update_note_view.dart';
import 'package:practice_app/Views/notes/notes_view.dart';
import 'package:practice_app/Views/register_view.dart';
import 'package:practice_app/Views/verfyemail_view.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/helpers/loading/loading_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state){
        if(state is AuthStateLoggedIn){
          return const NotesView();
        } else if(state is AuthStateNeedsVerification){
          return const VerifyEmailView();
        } else if(state is AuthStateLoggedOut){
          return const LoginView();
        } else if(state is AuthStateForgotPassword){
          return const ForgotPasswordView();
        }
         else if(state is AuthStateRegistering){
          return const RegisterView();
        }
         else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }, listener: (context, state) { 
        if(state.isLoading){
          LoadingScreen().show(
            context: context, 
            text: "Please wait a moment",
            color: Theme.of(context).colorScheme.primary,);
        }else{
          LoadingScreen().hide();
        }
       },);
  }
}
