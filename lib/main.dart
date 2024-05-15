import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_app/Views/login_view.dart';
import 'package:practice_app/firebase_options.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),),
        body: FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              
              case ConnectionState.done:
                // final user = FirebaseAuth.instance.currentUser;
                // if (user?. emailVerified ?? false){
                //   return const Text("Done");
                // }
                // else{
                //   return const VerifyEmailView();
                // }
                return const LoginView();
          default: return const Text("Loading....");
            }
           
          },
         
        ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const Text("Please Verify Email"),
          TextButton(onPressed: ()async{
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          }, 
          child: const Text("Send Email verification"),
          )
        ],
      );
  }
}