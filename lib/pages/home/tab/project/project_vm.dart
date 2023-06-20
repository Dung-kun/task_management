import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_list/constants/constants.dart';
import 'package:to_do_list/util/extension/string_extension.dart';
import 'package:uuid/uuid.dart';

import '/base/base_view_model.dart';
import '/models/project_model.dart';

var uuid = Uuid();

class ProjectViewModel extends BaseViewModel {
  BehaviorSubject<List<ProjectModel>?> bsProject = BehaviorSubject();
  BehaviorSubject<List<String>> bsMemberEmail =
  BehaviorSubject<List<String>>.seeded([]);

  ProjectViewModel(ref) : super(ref) {
    if (user != null)
      firestoreService.projectStreamWithListMember(user!.uid).listen((event) {
        bsProject.add(event);
      });
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
      listMember: [],
    );
    firestoreService.addProject(temp, id);
    List<String> list = List.from(bsMemberEmail.value);
    list.forEach((element) {
      sendEmail(element, id, name);
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
    if(email.isValidEmail()) {
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

  void sendEmail(String email, String id, String nameProject) async {
    var checkEmail = await firestoreService.getUserByEmail(email);
    var name =
        AppStrings.hiMail + user!.displayName.toString() + AppStrings.nameMail + nameProject + " project";
    var message = AppStrings.noAccountMessage;
    var messageLink = AppStrings.messageLinkRegister + "/$id";

    if (checkEmail.email != "") {
      message = AppStrings.alreadyAccountMessage;
      messageLink = AppStrings.messageLinkAccepted + "/$id" +"/${checkEmail.uid}";
    }
    await this.formatEmail(
        name: name,
        email: email,
        subject: AppStrings.subject,
        message: message,
        messageLink: messageLink);

    this.firestoreService.servicesResultPrint("Success add project");
  }

  Future<void> formatEmail(
      {required String name,
        required String email,
        required String subject,
        required String message,
        required String messageLink}) async {
    final serviceId = 'service_pkts95x';
    final templateId = 'template_8mnp03b';
    final userId = 'oIm3HT5ZKpZhr3dYj';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await http
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': "Guy",
          'user_email': email,
          'user_subject': subject,
          'message': message,
          'message_link': messageLink,
          'me': "Dung kun"
        },
        'accessToken': '7LDdrxK1cr5cecdcgYq55'
      }),
    )
        .then((value) => {print(value.body)})
        .catchError((err) => {print(err)});
  }

  @override
  void dispose() {
    bsProject.close();
    super.dispose();
  }
}
