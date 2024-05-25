import 'package:flutter/material.dart';
import 'package:practice_app/Services/crud/notes_service.dart';
import 'package:practice_app/constants/routes.dart';
import 'package:practice_app/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {

  final List<DatabaseNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NotesListView({
    super.key, 
    required this.notes, 
    required this.onDeleteNote,
    required this.onTap,
    });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index){
                            final note = notes[index];
                            return ListTile(
                              title: Text(note.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black),
                                softWrap: true,
                              ),
                              // subtitle: Text(note.description),
                              onTap: (){
                                onTap(note);
                              },
                              leading: IconButton(onPressed: (){
                                 Navigator.of(context).pushNamed(notesRoute, 
                                 arguments: note,
                                 );
                              }, icon: const Icon(Icons.note),
                                 color: Colors.yellow,
                              ),
                              trailing: IconButton(onPressed: () async{
                                final shouldDelete = await showDeleteDialog(context);
                                if(shouldDelete){
                                  onDeleteNote(note);
                                }
                              }, icon: const Icon(Icons.delete),
                                 color: Colors.red,
                              ),

                            );
                          },
                          );
  }
}