import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_app/firebase_options.dart';

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
        title: const Text("Login"),),
        body: FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              
              case ConnectionState.done:
                
                 return  Column(
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
                           final UserCredential = await FirebaseAuth.instance.
                        signInWithEmailAndPassword(
                          email: email, 
                          password: password);
                
                          debugPrint(UserCredential as String?);
                        }
                        on FirebaseAuthException catch(e){
                          if (e.code == "user-not-found"){
                            debugPrint("User not found");
                          }
                          else if (e.code == "wrong-password"){
                            debugPrint("Wrong password");
                          }
                       }
                      }, 
                      child: const Text("Login"),),
                   ],
          );
          default: return const Text("Loading....");
            }
           
          },
         
        ),
    );
  }
}

