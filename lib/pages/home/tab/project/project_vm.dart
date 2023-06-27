import 'package:to_do_list/services/email_service.dart';
import 'package:to_do_list/util/extension/string_extension.dart';
import 'package:uuid/uuid.dart';

import '/base/base_view_model.dart';
import '/models/project_model.dart';

var uuid = Uuid();

class ProjectViewModel extends BaseViewModel {
  BehaviorSubject<List<ProjectModel>?> bsProject = BehaviorSubject();
  BehaviorSubject<List<String>> bsMemberEmail =
      BehaviorSubject<List<String>>.seeded([]);
  EmailService _emailService = new EmailService();

  ProjectViewModel(ref) : super(ref) {
    if (user != null)
      firestoreService.projectStreamWithListMember(user!.uid).listen((event) {
        if(!bsProject.isClosed) bsProject.add(event);
      });
  }

  String getUid() {
    return user?.uid ?? "";
  }

  void addProject(String name, int indexColor) async {
    var id = uuid.v4();

    var temp = new ProjectModel(
      id: id,
      name: name,
      idAuthor: user!.uid,
      indexColor: indexColor,
      timeCreate: DateTime.now(),
      listTask: [],
      listMember: [user!.uid],
    );
    firestoreService.addProject(temp, id);
    sendEmail(id, name);

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

  void deleteProject(ProjectModel project) {
    firestoreService.deleteProject(project);
    for (var task in project.listTask) {
      firestoreService.deleteTask(task);
    }
  }

  void addMemberEmail(String email) {
    if (email.isValidEmail()) {
      List<String> list = [];
      if(bsMemberEmail.hasValue) list = List.from(bsMemberEmail.value);
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

  @override
  void dispose() {
    bsProject.close();
    bsMemberEmail.close();
    super.dispose();
  }
}
