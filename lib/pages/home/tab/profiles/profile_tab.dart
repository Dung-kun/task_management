import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/models/quick_note_model.dart';
import 'package:to_do_list/constants/constants.dart';
import 'package:to_do_list/routing/app_routes.dart';

import '../../../../models/project_model.dart';
import '/base/base_state.dart';
import '/util/extension/dimens.dart';
import '/util/extension/widget_extension.dart';
import 'profile_provider.dart';
import 'profile_vm.dart';

class ProfileTab extends StatefulWidget {
  final ScopedReader watch;
  final ProjectModel? mode;
  static Widget instance({ProjectModel? mode}) {
    return Consumer(builder: (context, watch, _) {
      return ProfileTab._(watch, mode);
    });
  }

  const ProfileTab._(this.watch, this.mode);

  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends BaseState<ProfileTab, ProfileViewModel> {
  User? localUser;

  int noteLength = 0;
  int noteSuccessfulLength = 0;

  int checkListLength = 0;
  int checkListSuccessfulLength = 0;

  int taskLength = 0;
  int taskSuccessfulLength = 0;

  @override
  void initState() {
    super.initState();
    initQuickNoteState();
  }

  void initQuickNoteState() {
    getVm().bsListTask.listen((value) {
      if (value != null) {
        setState(() {
          taskSuccessfulLength =
              value.where((element) => element.completed).toList().length;
          taskLength = value.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackground,
      body: localUser == null ? 'Loading'.desc() : buildBody(),
      appBar: buildAppBar(),
    );
  }

  Widget buildBody() {
    return Container(
      child: Container(
        color: AppColors.kPrimaryBackground,
        height: screenHeight,
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() => StringTranslateExtension('profiles')
      .tr()
      .plainAppBar(color: AppColors.kText)
      .backgroundColor(AppColors.kPrimaryBackground)
      .bAppBar();

  @override
  ProfileViewModel getVm() => widget.watch(viewModelProvider).state;
}
