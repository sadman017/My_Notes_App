
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_app/Views/login_view.dart';
import 'package:practice_app/Views/register_view.dart';
import 'package:practice_app/constants/routes.dart';
// import 'package:practice_app/Views/verfyemail_view.dart';
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
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
       notesRoute: (context) => const NotesView(),
      },
    ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                  ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              
              case ConnectionState.done:
                 final user = FirebaseAuth.instance.currentUser;
                 if (user !=null){
                  if (user.emailVerified){
                    return const NotesView();
                  }else{
                    return const NotesView();
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
enum MenuAction {logout}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value)async{
           switch(value){
            
             case MenuAction.logout:
               final shouldLogout = await showLogOutDialog(context);
               if(shouldLogout){
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false,);
               }
           }
          }, itemBuilder: (context){
           return const [ PopupMenuItem<MenuAction>(value:MenuAction.logout, child: Text("Log out")
           ),];
          })
        ],
        ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: const Text("Sign out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text("Cancel"),),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: const Text("Log out"),),
        ],
      );
    }).then((value) => value ?? false);
}