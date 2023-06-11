import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({Key? key, this.message});

  // const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Center(
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }
}
