import 'package:flutter/material.dart';

import '/base/base_state.dart';
import '/constants/constants.dart';
import '/models/project_model.dart';
import 'project_provider.dart';
import 'project_vm.dart';

class ProjectTab extends StatefulWidget {
  final ScopedReader watch;

  final Function pressMode;
  final ProjectModel? mode;

  static Widget instance({ProjectModel? mode, required Function pressMode}) {
    return Consumer(builder: (context, watch, _) {
      return ProjectTab._(watch, mode, pressMode);
    });
  }

  const ProjectTab._(this.watch, this.mode, this.pressMode);

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
    return SingleChildScrollView(child: Container());
  }

  @override
  ProjectViewModel getVm() => widget.watch(viewModelProvider).state;
}
