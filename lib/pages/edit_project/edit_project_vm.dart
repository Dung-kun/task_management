import 'package:to_do_list/base/base_view_model.dart';
import 'package:to_do_list/models/project_model.dart';
import 'package:to_do_list/models/task_model.dart';
import 'package:to_do_list/util/extension/string_extension.dart';

import '../../models/meta_user_model.dart';
import '../../services/email_service.dart';

class EditProjectViewModel extends BaseViewModel {
  BehaviorSubject<ProjectModel?> bsProject = BehaviorSubject<ProjectModel?>();
  BehaviorSubject<List<MetaUserModel>?> bsListMember =
      BehaviorSubject<List<MetaUserModel>>();
  BehaviorSubject<List<TaskModel>?> bsListTask =
      BehaviorSubject<List<TaskModel>?>();
  BehaviorSubject<List<String>> bsMemberEmail =
      BehaviorSubject<List<String>>.seeded([]);
  EmailService _emailService = new EmailService();
  List<String> deleteUserList = [];
  List<String> deleteTaskList = [];

  EditProjectViewModel(ref) : super(ref) {
    // add project data
    // if (user != null) {
    //   firestoreService.projectStreamById(user!.uid).listen((event) {
    //     bsProject.add(event);
    //   });
    // }
  }

  loadProject(String idProject) {
    firestoreService.projectStreamById(idProject).listen((event) {
      bsProject.add(event);
      List<MetaUserModel> listMem = [];
      List<TaskModel> listTask = [];

      if (listTask != [] && bsProject.value!.listMember.length > 0) {
        for (var mem in bsProject.value!.listMember) {
          firestoreService
              .getUserById(mem)
              .then((value) => {listMem.add(value), bsListMember.add(listMem)});
        }
      }

      if (listTask != [] && bsProject.value!.listTask.length > 0) {
        for (var task in bsProject.value!.listTask) {
          firestoreService
              .getTaskById(task)
              .then((value) => {listTask.add(value), bsListTask.add(listTask)});
        }
        ;
      }
    });
  }

  deleteMember(MetaUserModel meUser) {
    List<MetaUserModel> listMem = List.from(bsListMember.value ?? []);
    if (listMem.contains(meUser)) {
      deleteUserList.add(meUser.uid);
      listMem.remove(meUser);
    }

    bsListMember.add(listMem);
  }

  deleteTask(TaskModel task) {
    List<TaskModel> listTask = List.from(bsListTask.value ?? []);
    if (listTask.contains(task)) {
      deleteTaskList.add(task.id);
      listTask.remove(task);
    }

    bsListTask.add(listTask);
  }

  updateProject(String name, String uid) {
    List<String> member = List.from(bsListMember.value!.map((e) => e.uid));
    firestoreService.updateProject(uid, name, member);


    sendEmail(uid, name);
    var task = bsListTask.value!;

    for (var i = 0; i < task.length; i++) {
      for (var item in deleteUserList) {
        if (task[i].listMember.contains(item)) {
          task[i].listMember.remove(item);
        }
        firestoreService.updateTaskById(task[i].id, task[i].listMember);
      }
    }
  }

  void addMemberEmail(String email) {
    if (email.isValidEmail()) {
      List<String> list = List.from(bsMemberEmail.value);

      if (!list.contains(email)) {
        list = [email, ...list];
      }

      bsMemberEmail.add(list);
    }
  }

  void deleteMemberEmail(String email) {
    List<String> list = List.from(bsMemberEmail.value);

    if (list.contains(email)) {
      list.remove(email);
    }
    bsMemberEmail.add(list);
  }

  void sendEmail(String id, String name) {
    List<String> list = List.from(bsMemberEmail.value);
    list.forEach((element) {
      firestoreService.getUserByEmail(element).then((value) => {
         _emailService.sendEmail(
            element, id, name, user!.displayName ?? "", value)
      });
    });

    bsMemberEmail.add([]);
  }

  void dispose() {
    bsListTask.close();
    bsListMember.close();
    super.dispose();
  }
}
