import 'package:flutter/material.dart';

class AddProjectButton extends StatelessWidget {
  const AddProjectButton({Key? key, required this.press}) : super(key: key);

  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> showAddProjectDialog(BuildContext context) async {
    int indexChooseColor = 0;
    final _formKey = GlobalKey<FormState>();
    TextEditingController _projectController = TextEditingController();
  }
}
