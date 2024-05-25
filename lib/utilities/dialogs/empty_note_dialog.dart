import 'package:flutter/material.dart';
import 'package:practice_app/utilities/dialogs/generic_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context){
  return showGenericDialog<void>(
    context: context, 
    title: "Sharing", 
    content: "You can't share an empty note!", 
    optionsBuilder: () => {
      "OK" : null,
    },
    );
}