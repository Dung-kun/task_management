import 'package:to_do_list/models/meta_user_model.dart';

import '/models/task_model.dart';

import '/base/base_view_model.dart';
import '/models/project_model.dart';

class EditTaskViewModel extends BaseViewModel {
  BehaviorSubject<TaskModel?> bsTask = BehaviorSubject<TaskModel?>();
  BehaviorSubject<ProjectModel?> bsProject = BehaviorSubject<ProjectModel?>();
  BehaviorSubject<List<MetaUserModel>?> bsListMember =
      BehaviorSubject<List<MetaUserModel>>();
  BehaviorSubject<List<MetaUserModel>?> bsListMemberInProject =
  BehaviorSubject<List<MetaUserModel>>();


  EditTaskViewModel(ref) : super(ref) {
    // add project data
    if (user != null) {
    }
  }

  void loadTask(String taskId) {
    firestoreService.getTaskById(taskId).then((event) {
      bsTask.add(event);
      List<MetaUserModel> listMem = [];
      if (bsTask.value!.listMember.length > 0) {
        for (var mem in bsTask.value!.listMember) {
          firestoreService.getUserById(mem).then((event) {
            listMem.add(event);
            bsListMember.add(listMem);
          });
        }
      } else {
        bsListMember.add(listMem);
      }
      if(event.idProject != "") {
        firestoreService.getProjectById(event.idProject).then((value) => {
          bsProject.add(value),
          loadMemberInProject(value.listMember)
        });
      }
    });
  }


  void loadMemberInProject(List<String> members) async {
    List<MetaUserModel> listMember = [];
    for (var mem in members) {
      firestoreService.userStreamById(mem).listen((event) {
        listMember.add(event);
        bsListMemberInProject.add(listMember);
      });
    }
  }

  Future<String> editTask(TaskModel task, List<String> oldMemberList) async {
    startRunning();
    // add task to database
    String result = 'failed';
    bool hasUpdateTask = await firestoreService.updateTask(task);
    if (hasUpdateTask) result = 'success';

    sendNotification(task, oldMemberList, task.listMember);
    endRunning();
    return result;
  }

  bool sendNotification(
      TaskModel task, List<String> oldMemList, List<String> newMemList) {
    try {
      if (oldMemList.isEmpty && newMemList.isEmpty) {
        print("no member was add or remove");
        return false;
      }

      List<String> deletedMem = new List.from(oldMemList);
      deletedMem.removeWhere((element) => newMemList.contains(element));

      List<String> addedMem = new List.from(newMemList);
      addedMem.removeWhere((element) => oldMemList.contains(element));

      List<String> remainMem = new List.from(oldMemList);
      remainMem.removeWhere((element) => !newMemList.contains(element));
      print("old members: ${oldMemList}");
      print("new members: ${newMemList}");
      print("delete members: ${deletedMem}");
      print("added members: ${addedMem}");
      print("remain members: ${remainMem}");
      for (var mem in deletedMem) {
        firestoreService.getUserById(mem).then((user) async => {
              if (user.token != null)
                await firestoreMessagingService.sendPushMessaging(
                    user.token!,
                    "YOU HAS BEEN KICK",
                    "you has been remove from task ${task.title}")
            });
      }
      for (var mem in addedMem) {
        firestoreService.getUserById(mem).then((user) async => {
              if (user.token != null)
                await firestoreMessagingService.sendPushMessaging(user.token!,
                    "JOIN TASK", "you has been add to task ${task.title}")
            });
      }
      for (var mem in remainMem) {
        firestoreService.getUserById(mem).then((user) async => {
              if (user.token != null)
                await firestoreMessagingService.sendPushMessaging(
                    user.token!,
                    "TASK MEMBER CHANGE",
                    "members of task ${task.title} has been change")
            });
      }
      print("notification has been sended to all member");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> uploadDesTask(String taskId, String filePath) async {
    startRunning();
    await fireStorageService.uploadTaskImage(filePath, taskId);
    String url = await fireStorageService.loadTaskImage(taskId);
    firestoreService.updateDescriptionUrlTaskById(taskId, url);
    endRunning();
  }

  @override
  void dispose() {
    bsTask.close();
    bsProject.close();
    bsListMemberInProject.close();
    bsListMember.close();
    super.dispose();
  }
}
