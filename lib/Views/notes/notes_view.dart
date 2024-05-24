import 'package:flutter/material.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/Services/crud/notes_service.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/enums/menu_acton.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final NotesService _notesService;
  String? get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState(){
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(newNoteRoute);
          }, 
          icon: const Icon(Icons.add),),
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
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail ?? "",), 
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                return StreamBuilder(
                stream: _notesService.allNotes,
                 builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if(snapshot.hasData){
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context, index){
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(note.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black),
                                softWrap: true,
                              ),
                              // subtitle: Text(note.description),
                              onTap: (){
                              
                              },
                              leading: IconButton(onPressed: (){
                                // Navigator.of(context).pushNamed(deleteNoteRoute, arguments: note);
                              }, icon: const Icon(Icons.note),),
                              trailing: IconButton(onPressed: (){
                                // Navigator.of(context).pushNamed(editNoteRoute, arguments: note);
                              }, icon: const Icon(Icons.edit),),

                            );
                          },
                          );
                      }else{
                        return const Center(child: CircularProgressIndicator());
                      }
                      default:
                        return const Center(child: CircularProgressIndicator());
                  }
                 });
                 default:
                  return const Center(child: CircularProgressIndicator());
          }
          }
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