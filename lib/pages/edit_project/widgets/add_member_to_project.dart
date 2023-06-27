import 'package:flutter/material.dart';
import 'package:to_do_list/base/base_state.dart';
import 'package:to_do_list/util/extension/extension.dart';
import 'package:to_do_list/util/extension/string_extension.dart';

import '../../../base/base_view_model.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/strings.dart';
import '../../../util/ui/common_widget/primary_button.dart';
import '../../home/tab/project/widgets/member_email_item.dart';

class AddMemberToProject extends StatelessWidget {
  const AddMemberToProject(
      {Key? key,
      required this.press,
      required this.addMemberEmail,
      required this.bsMemberEmail,
      required this.deleteMemberEmail})
      : super(key: key);

  final BehaviorSubject<List<String>> bsMemberEmail;
  final Function deleteMemberEmail;
  final Function press;
  final Function addMemberEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.green,
      ),
      child: "Add"
          .plain()
          .fSize(14)
          .color(Colors.white)
          .weight(FontWeight.bold)
          .b()
          .center(),
    ).inkTap(
      onTap: () => {showAddProjectDialog(context)},
      borderRadius: BorderRadius.circular(5.r),
    );
  }

  Future<void> showAddProjectDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailFormatController = TextEditingController();
    return await showDialog(
      barrierColor: AppColors.kBarrierColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          void _setEmailFormatController() {
            setState(() {
              _emailFormatController.text = "";
            });
          }

          return StreamBuilder<List<String>>(
            stream: bsMemberEmail,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AppStrings.loading.text12().tr().center();
              }

              List<String> data = snapshot.data!;
              return AlertDialog(
                contentPadding: EdgeInsets.all(24),
                content: Container(
                  width: screenWidth,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppStrings.addMember
                              .plain()
                              .fSize(18)
                              .weight(FontWeight.bold)
                              .b(),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: new InputDecoration(
                              suffixIcon: Icon(
                                Icons.add,
                                color: Colors.redAccent,
                              ).inkTap(
                                  onTap: () => {
                                        addMemberEmail(
                                            _emailFormatController.text)
                                      },
                                  borderRadius: BorderRadius.circular(5)),
                              errorStyle: TextStyle(fontSize: 18.0),
                              labelText: 'Add member',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(
                                    color: Colors.blue,
                                  )),
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                            ),
                            style: new TextStyle(color: Colors.black),
                            validator: (val) =>
                                (val!.isValidEmail() || val.isEmpty)
                                    ? null
                                    : StringTranslateExtension(AppStrings
                                            .pleaseEnterIncorrectFormatEmail)
                                        .tr(),
                            controller: _emailFormatController,
                          ),
                          SizedBox(height: 8),
                          for (int i = 0; i < data.length; i++)
                            MemberEmailItem(
                                deleteMemberEmail: () =>
                                {deleteMemberEmail(data[i])},
                                nameEmail: data[i]
                            ),
                          SizedBox(height: 20),
                          PrimaryButton(
                            text:
                                StringTranslateExtension(AppStrings.done).tr(),
                            press: () {
                              press();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}
