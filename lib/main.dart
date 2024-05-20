
import 'package:flutter/material.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/Views/login_view.dart';
import 'package:practice_app/Views/notes_view.dart';
import 'package:practice_app/Views/register_view.dart';
import 'package:practice_app/Views/verfyemail_view.dart';
import 'package:practice_app/constants/routes.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
       notesRoute: (context) => const NotesView(),
       verifyEmailRoute:(context) => const VerifyEmailView(),
      },
    ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              
              case ConnectionState.done:
                 final user = AuthService.firebase().currentUser;
                 if (user !=null){
                  if (user.isEmailVerified){
                    return const NotesView();
                  }else{
                    return const VerifyEmailView();
                  }
                 }else{
                     return const LoginView();
                 }
                
          default: return const CircularProgressIndicator();
            }
           
          },
         
        );
  }
}
