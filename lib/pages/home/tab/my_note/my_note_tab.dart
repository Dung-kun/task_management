import 'package:flutter/material.dart';

import '/base/base_state.dart';
import '/constants/app_colors.dart';
import '/models/quick_note_model.dart';
import '/routing/app_routes.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import '../../../../models/project_model.dart';
import 'my_note_provider.dart';
import 'my_note_vm.dart';

class MyNoteTab extends StatefulWidget {
  final ScopedReader watch;
  final ProjectModel? mode;

  static Widget instance({ProjectModel? mode}) {
    return Consumer(builder: (context, watch, _) {
      return MyNoteTab._(watch, mode);
    });
  }

  const MyNoteTab._(this.watch, this.mode);

  @override
  State<StatefulWidget> createState() {
    return MyNoteState();
  }
}

class MyNoteState extends BaseState<MyNoteTab, MyNoteViewModel> {
  bool isFullQuickNote = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      appBar: buildAppBar(),
    );
  }

  Widget buildBody() {
    return Container(
      color: AppColors.kPrimaryBackground,
      height: screenHeight,
      width: screenWidth,
    );
  }

  AppBar buildAppBar() => 'Quick Notes'
          .plainAppBar(color: AppColors.kText)
          .backgroundColor(AppColors.kPrimaryBackground)
          .actions(
        [
          Switch(
            value: isFullQuickNote,
            onChanged: (value) {
              setState(() {
                isFullQuickNote = !isFullQuickNote;
              });
            },
          ),
        ],
      ).bAppBar();

  Widget buildNoneNote() =>
      'You are not have a note, create a note to continue'.desc().inkTap(
        onTap: () {
          Get.toNamed(AppRoutes.NEW_NOTE);
        },
      );

  @override
  MyNoteViewModel getVm() => widget.watch(viewModelProvider).state;
}
