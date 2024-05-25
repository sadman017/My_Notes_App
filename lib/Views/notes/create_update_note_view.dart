import 'package:flutter/material.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/Services/cloud/cloud_note.dart';
import 'package:practice_app/Services/cloud/firebase_cloud_storage.dart';
import 'package:practice_app/utilities/dialogs/empty_note_dialog.dart';
import 'package:practice_app/utilities/generics/get_argument.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {

  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async{
    final note = _note;
    if(note == null){
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId, 
      text: text,
     );
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async{
    final widgetNote = context.getArgument<CloudNote>();
    
    if(widgetNote != null){
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if(existingNote!= null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId =currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty(){
    final note = _note;
    if(note!= null && _textController.text.isEmpty){
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async{
    final note = _note;
    final text =  _textController.text;
    if(note!= null && text.isNotEmpty){
     await  _notesService.updateNote(
      documentId: note.documentId, 
      text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('New Note'),
        actions: [
          IconButton(
            onPressed: () async{
              final text = _textController.text;
              if(_note == null || text.isEmpty){
                await  cannotShareEmptyNoteDialog(context);
              }else{
                Share.share(text);
              }
            }, 
            icon: const Icon(Icons.share),
            tooltip: 'Share note',
            color: Colors.blue,
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context), 
        builder: (context,  snapshot){
          switch (snapshot.connectionState){
            
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Type your note here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),),
              );
              default:
              return const Center(child: CircularProgressIndicator());
          }
        },)
    );
  }
}