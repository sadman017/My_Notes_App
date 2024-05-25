import 'package:flutter/material.dart';
import 'package:practice_app/Services/crud/notes_service.dart';
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
                                // Navigator.of(context).pushNamed(deleteNoteRoute, arguments: note);
                              }, icon: const Icon(Icons.note),),
                              trailing: IconButton(onPressed: () async{
                                // Navigator.of(context).pushNamed(editNoteRoute, arguments: note);
                                final shouldDelete = await showDeleteDialog(context);
                                if(shouldDelete){
                                  onDeleteNote(note);
                                }
                              }, icon: const Icon(Icons.delete),),

                            );
                          },
                          );
  }
}