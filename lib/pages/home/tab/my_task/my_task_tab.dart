import 'package:flutter/material.dart';
import 'package:to_do_list/models/project_model.dart';

import '/base/base_state.dart';
import '/constants/constants.dart';
import '/pages/home/tab/my_task/my_task_vm.dart';
import '/util/extension/widget_extension.dart';
import 'my_task_provider.dart';

class MyTaskTab extends StatefulWidget {
  final ScopedReader watch;

  final ProjectModel? mode;
  final Function closeProjectMode;

  static Widget instance(
      {ProjectModel? mode, required Function closeProjectMode}) {
    return Consumer(builder: (context, watch, _) {
      return MyTaskTab._(watch, mode, closeProjectMode);
    });
  }

  const MyTaskTab._(this.watch, this.mode, this.closeProjectMode);

  @override
  State<StatefulWidget> createState() {
    return MyTaskState();
  }
}

class MyTaskState extends BaseState<MyTaskTab, MyTaskViewModel> {
  bool isToDay = true;
  var isSelectedDay;
  taskDisplayStatus taskStatus = taskDisplayStatus.allTasks;

  @override
  void initState() {
    super.initState();

    getVm().bsIsToDay.listen((value) {
      setState(() {
        isToDay = value;
      });
    });

    getVm().bsIsSelectedDay.listen((value) {
      setState(() {
        isSelectedDay = value;
      });
    });

    getVm().bsTaskDisplayStatus.listen((value) {
      setState(() {
        taskStatus = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryBackground,
      body: buildBody(),
      appBar: buildAppBar(),
    );
  }

  Widget buildBody() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  AppBar appBar() => AppBar();

  AppBar buildAppBar() {
    String title = widget.mode == null
        ? StringTranslateExtension(AppStrings.workList).tr()
        : widget.mode!.name;
    return title
        .plainAppBar()
        .leading(
          widget.mode == null
              ? null
              : IconButton(
                  onPressed: () => widget.closeProjectMode(),
                  icon: Icon(Icons.arrow_back_ios),
                ),
        )
        .backgroundColor(
          widget.mode == null
              ? AppColors.kPrimaryColor
              : AppColors.kColorNote[widget.mode!.indexColor],
        )
        .actions(
      [],
    ).bAppBar();
  }

  @override
  MyTaskViewModel getVm() => widget.watch(viewModelProvider).state;
}
