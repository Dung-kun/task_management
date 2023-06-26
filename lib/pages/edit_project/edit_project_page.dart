import 'package:flutter/material.dart';
import 'package:to_do_list/models/project_model.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/pages/edit_project/edit_project_vm.dart';
import 'package:to_do_list/pages/edit_project/widgets/add_member_to_project.dart';
import 'package:to_do_list/pages/edit_project/widgets/member_item.dart';
import 'package:to_do_list/pages/edit_project/widgets/title_form.dart';
import 'package:to_do_list/util/extension/extension.dart';
import 'package:to_do_list/util/ui/common_widget/task_card.dart';

import '../../base/base_state.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/strings.dart';
import '../../models/meta_user_model.dart';
import '../../routing/app_routes.dart';
import '../../util/ui/common_widget/primary_button.dart';
import '../edit_project/edit_project_provider.dart';

class EditProjectPage extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return EditProjectPage._(watch);
    });
  }

  const EditProjectPage._(this.watch);

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState
    extends BaseState<EditProjectPage, EditProjectViewModel> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    getVm().loadProject(Get.arguments);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getVm().bsListMember.add([]);
    getVm().bsListTask.add([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: screenWidth,
            height: 44.w,
            child: Container(color: AppColors.kPrimaryColor_yellow),
          ),
          buildForm(),
        ],
      ),
    );
  }

  Widget buildForm() => Positioned(
        top: 10,
        left: 0,
        width: screenWidth,
        height: screenHeight - buildAppBar().preferredSize.height - 100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: AppConstants.kFormShadow,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: StreamBuilder<ProjectModel?>(
                  stream: getVm().bsProject,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return AppStrings.somethingWentWrong
                          .text12()
                          .tr()
                          .center();
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AppStrings.loading.text12().tr().center();
                    }
                    ProjectModel project = snapshot.data!;
                    titleController.text = project.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.w),
                          Text(
                            "Project name",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackText),
                          ),
                          SizedBox(height: 10.w),
                          buildTitleForm(),
                          SizedBox(height: 16.w),
                          buildMemberForm(),
                          SizedBox(height: 16.w),
                          buildListTask(),
                          SizedBox(height: 16.w),
                          buildDoneButton(),
                          SizedBox(height: 30.w),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ).pad(0, 12),
      );

  Widget buildTitleForm() {
    return TitleForm(controller: titleController);
  }

  Widget buildMemberForm() {
    return StreamBuilder<List<MetaUserModel>?>(
      stream: getVm().bsListMember,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AppStrings.somethingWentWrong.text12().tr().center();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppStrings.loading.text12().tr().center();
        }

        List<MetaUserModel> data = snapshot.data!;
        print("$data");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Member List",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText),
                ),
                //
                AddMemberToProject(
                    press: () => getVm().sendEmail(getVm().bsProject.value!.id,
                        getVm().bsProject.value!.name),
                    addMemberEmail: getVm().addMemberEmail,
                    bsMemberEmail: getVm().bsMemberEmail,
                    deleteMemberEmail: getVm().deleteMemberEmail)
              ],
            ),
            SizedBox(height: 12.w),
            for (int i = 0; i < data.length; i++)
              if (data[i].uid != getVm().user!.uid)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: MemberItem(
                    userModel: data[i],
                    press: () => getVm().deleteMember(data[i]),
                  ),
                )
          ],
        );
      },
    );
  }

  Widget buildListTask() {
    return StreamBuilder<List<TaskModel>?>(
        stream: getVm().bsListTask,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return AppStrings.somethingWentWrong.text12().tr().center();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppStrings.loading.text12().tr().center();
          }

          List<TaskModel> statusDataAndMode = snapshot.data!;
          statusDataAndMode.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          print("$statusDataAndMode");
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Task List",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackText),
                  ),
                  buildAddTaskButton()
                ],
              ),
              SizedBox(height: 12.w),
              for (int i = 0; i < statusDataAndMode.length; i++)
                if (i == 0 ||
                    statusDataAndMode[i - 1].dueDate.year !=
                        statusDataAndMode[i].dueDate.year ||
                    statusDataAndMode[i - 1].dueDate.month !=
                        statusDataAndMode[i].dueDate.month ||
                    statusDataAndMode[i - 1].dueDate.day !=
                        statusDataAndMode[i].dueDate.day)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      toDateString(statusDataAndMode[i].dueDate)
                          .plain()
                          .color(AppColors.kGrayTextC)
                          .fSize(13.0)
                          .weight(FontWeight.w600)
                          .b()
                          .pad(10, 0, 10, 5),
                      ListTile(
                        title: TaskCard(
                          task: statusDataAndMode[i],
                        ),
                        trailing: Container(
                          height: double.infinity,
                          child: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ).inkTap(
                            onTap: () =>
                                getVm().deleteTask(statusDataAndMode[i]),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      )
                    ],
                  )
                else
                  ListTile(
                    title: TaskCard(
                      task: statusDataAndMode[i],
                    ),
                    trailing: Container(
                      height: double.infinity,
                      child: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ).inkTap(
                        onTap: () => getVm().deleteTask(statusDataAndMode[i]),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
            ],
          );
        });
  }

  Widget buildDoneButton() => PrimaryButton(
        text: StringTranslateExtension(AppStrings.editProject).tr(),
        press: () => { getVm().updateProject(titleController.text), Get.back() },
        backgroundColor: AppColors.kPrimaryColor_yellow,
        disable: !onRunning,
      ).pad(0, 12);

  Widget buildAddTaskButton() => Container(
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
        onTap: () => {
          Get.offAndToNamed(AppRoutes.NEW_TASK, arguments: getVm().bsProject.value??null)
        },
        borderRadius: BorderRadius.circular(5.r),
      );

  AppBar buildAppBar() => StringTranslateExtension(AppStrings.editProject)
      .tr()
      .plainAppBar()
      .backgroundColor(AppColors.kPrimaryColor_yellow)
      .bAppBar();

  @override
  EditProjectViewModel getVm() => widget.watch(viewModelProvider).state;
}
