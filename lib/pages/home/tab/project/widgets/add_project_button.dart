import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_do_list/util/extension/string_extension.dart';

import '/constants/constants.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import '../../../../../util/ui/common_widget/choose_color_icon.dart';
import '../../../../../util/ui/common_widget/primary_button.dart';
import 'member_email_item.dart';

class AddProjectButton extends StatelessWidget {
  const AddProjectButton(
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
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: AppColors.kColorNote[0],
      ),
      child: "+"
          .plain()
          .fSize(24)
          .color(Colors.white)
          .weight(FontWeight.bold)
          .b()
          .center(),
    )
        .inkTap(
          onTap: () => {showAddProjectDialog(context)},
          borderRadius: BorderRadius.circular(5.r),
        )
        .pad(20, 0, 12);
  }

  Future<void> showAddProjectDialog(BuildContext context) async {
    int indexChooseColor = 0;
    final _formKey = GlobalKey<FormState>();
    TextEditingController _projectController = TextEditingController();
    TextEditingController _emailFormatController = TextEditingController();
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
                          AppStrings.title
                              .plain()
                              .fSize(18)
                              .weight(FontWeight.bold)
                              .b()
                              .tr(),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: new InputDecoration(
                              errorStyle: TextStyle(fontSize: 18.0),
                              labelText: 'Title',
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
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: new InputDecoration(
                              suffixIcon: Icon(
                                Icons.add,
                                color: Colors.redAccent,
                              ).inkTap(
                                  onTap: () => {
                                        if (_formKey.currentState!.validate())
                                          {
                                            addMemberEmail(
                                                _emailFormatController.text),
                                            _setEmailFormatController()
                                          }
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
                                nameEmail: data[i]),
                          SizedBox(height: 20),
                          PrimaryButton(
                            text:
                                StringTranslateExtension(AppStrings.done).tr(),
                            press: () async {
                              if (_formKey.currentState!.validate() || _emailFormatController.text == "") {
                                press(
                                    _projectController.text, indexChooseColor);
                                Get.back();
                              }
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
