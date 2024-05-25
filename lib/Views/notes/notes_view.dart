
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/Services/auth/bloc/auth_bloc.dart';
import 'package:practice_app/Services/auth/bloc/auth_event.dart';
import 'package:practice_app/Services/cloud/cloud_note.dart';
import 'package:practice_app/Services/cloud/firebase_cloud_storage.dart';
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

  late final FirebaseCloudStorage _notesService;
  String? get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState(){
    _notesService = FirebaseCloudStorage();
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
                context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
               }
           }
          }, itemBuilder: (context){
           return const [ PopupMenuItem<MenuAction>(value:MenuAction.logout, child: Text("Log out")
           ),];
          })
        ],
        ),
        body:  StreamBuilder(
                stream: _notesService.allNotes(ownerUserId: userId?? "  "),
                 builder: (context, snapshot){
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if(snapshot.hasData){
                        final allNotes = snapshot.data as Iterable<CloudNote>;
                        return NotesListView(
                          notes: allNotes, 
                          onDeleteNote: (note) async{
                            await _notesService.deleteNote(documentId: note.documentId);
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
                 }),
    );
  }
}

