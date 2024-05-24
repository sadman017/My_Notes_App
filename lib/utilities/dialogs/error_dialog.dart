import 'package:flutter/material.dart';
import 'package:practice_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context, 
  String text,
){
  return showGenericDialog(
  context: context, 
  title: "An error occured", 
  content: text, 
  optionsBuilder: () => {
    "OK" : null,
  },
  );
}