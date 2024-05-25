import 'package:flutter/material.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/Services/crud/notes_service.dart';
import 'package:practice_app/Views/notes/notes_list_view.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/enums/menu_acton.dart';
import 'package:practice_app/utilities/dialogs/logout_dialog.dart';

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
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
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
                        return NotesListView(
                          notes: allNotes, 
                          onDeleteNote: (note) async{
                            await _notesService.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
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

