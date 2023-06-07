import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/base/base_state.dart';
import '/constants/constants.dart';
import '/util/extension/dimens.dart';
import 'project_vm.dart';
import 'widgets/add_project_button.dart';

class ProjectTab extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ProjectState();
  }
}

class ProjectState extends BaseState<ProjectTab, ProjectViewModel> {
  bool isToDay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      backgroundColor: AppColors.kPrimaryBackground,
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(

    );
  }

  @override
  ProjectViewModel getVm() {
    // TODO: implement getVm
    throw UnimplementedError();
  }

}
