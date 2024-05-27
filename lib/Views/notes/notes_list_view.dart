import 'package:flutter/material.dart';
import 'package:practice_app/Services/cloud/cloud_note.dart';
import 'package:practice_app/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {

  final Iterable<CloudNote> notes;
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
                            final note = notes.elementAt(index);
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
                            //     final email = _email.text;
                            //     final password = _password.text;
                            //     context.read<AuthBloc>().add(
                            //       AuthEventLogIn(
                            //       email: email,
                            //       password: password,
                            //     ),
                            // );
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