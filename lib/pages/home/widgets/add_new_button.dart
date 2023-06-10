import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/constants/constants.dart';
import 'package:to_do_list/models/project_model.dart';
import 'package:to_do_list/routing/app_routes.dart';
import 'package:to_do_list/util/extension/dimens.dart';
import 'package:to_do_list/util/extension/widget_extension.dart';
import 'package:to_do_list/util/ui/common_widget/choose_color_icon.dart';
import 'package:to_do_list/util/ui/common_widget/primary_button.dart';

class AddNewButton extends StatelessWidget {
  const AddNewButton({Key? key, }) : super(key: key);

  // final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => showAddDialog(context),
      child: Container(
        margin: EdgeInsets.only(top: 40),
        width: size.width * .15,
        height: size.width * .15,
        decoration: BoxDecoration(
          //color: Colors.red,
          gradient: RadialGradient(
            colors: [
              Color(0xFFF68888),
              Color(0xFFF96060),
            ],
            center: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(56),
        ),
        child: Center(
          child: Text(
            "+",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void showAddDialog(BuildContext context) => showDialog(
        barrierColor: AppColors.kBarrierColor,
        context: context,
        builder: (context) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.all(0),
          children: <Widget>[
            SimpleDialogOption(
              padding: EdgeInsets.all(0),
              child: CreateItem(
                text: StringTranslateExtension(AppStrings.addTask).tr(),
                press: () {
                  Get.offAndToNamed(AppRoutes.NEW_TASK);
                },
              ),
            ),
            // SimpleDialogOption(
            //   padding: EdgeInsets.all(0),
            //   child: CreateItem(
            //     text: StringTranslateExtension(AppStrings.addProject).tr(),
            //     press: () => showAddProjectDialog(context),
            //   )
            // ),
          ],
        ),
      );
}

Future<void> showAddProjectDialog(BuildContext context) async {
  int indexChooseColor = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _projectController = TextEditingController();
  return await showDialog(
    barrierColor: AppColors.kBarrierColor,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        void _setColor(int index) {
          setState(() {
            indexChooseColor = index;
          });
        }

        return AlertDialog(
          contentPadding: EdgeInsets.all(24),
          content: Container(
            width: screenWidth,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppStrings.title
                      .plain()
                      .fSize(18)
                      .weight(FontWeight.bold)
                      .b(),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      // labelText: 'Enter your username',
                    ),
                    validator: (val) => val!.isNotEmpty
                        ? null
                        : StringTranslateExtension(
                        AppStrings.pleaseEnterYourText)
                        .tr(),
                    controller: _projectController,
                  ),
                  SizedBox(height: 16),
                  AppStrings.chooseColor
                      .plain()
                      .fSize(18)
                      .weight(FontWeight.bold)
                      .b()
                      .tr(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      for (int i = 0; i < 9; i++)
                        ChooseColorIcon(
                          index: i,
                          press: _setColor,
                          tick: i == indexChooseColor,
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  PrimaryButton(
                    text: StringTranslateExtension(AppStrings.done).tr(),
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        // press(_projectController.text, indexChooseColor);
                        Get.offAndToNamed(AppRoutes.HOME);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}

// void press(String text, int indexChooseColor) {
//   var temp = new ProjectModel(
//     name: text,
//     idAuthor: user!.uid,
//     indexColor: indexColor,
//     timeCreate: DateTime.now(),
//     listTask: [],
//   );
//   firestoreService.addProject(temp);
// }


class CreateItem extends StatelessWidget {
  const CreateItem({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 268,
      height: 71,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFE4E4E4).withOpacity(.4),
        ),
      ),
      // ignore: deprecated_member_use
      child: TextButton(
        onPressed: () => press(),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.kText,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
