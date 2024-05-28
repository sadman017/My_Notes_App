import 'package:flutter/widgets.dart';
import 'package:practice_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog(
    context: context, 
    title: "Passord Reset", 
    content: "We have sent you a password reset link.", 
    optionsBuilder: () => {
      "OK" : null,
    },
    );
}