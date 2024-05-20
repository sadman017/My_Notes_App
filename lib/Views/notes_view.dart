import 'package:flutter/material.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/enums/menu_acton.dart';

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
                await AuthService.firebase().logOut();
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