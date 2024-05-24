import 'package:flutter/material.dart';
import 'package:practice_app/Services/auth/auth_service.dart';
import 'package:practice_app/Services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {

  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
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
      note: note, 
      text: text,
     );
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createNewNote() async{
    final existingNote = _note;
    if(existingNote!= null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email =currentUser.email;
    final owner = await _notesService.getUser(email: email?? " ");
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty(){
    final note = _note;
    if(note!= null && _textController.text.isEmpty){
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async{
    final note = _note;
    final text =  _textController.text;
    if(note!= null && text.isNotEmpty){
     await  _notesService.updateNote(
      note: note, 
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
      ),
      body: FutureBuilder(
        future: createNewNote(), 
        builder: (context,  snapshot){
          switch (snapshot.connectionState){
            
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
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