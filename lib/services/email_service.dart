import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_list/models/meta_user_model.dart';

import '../constants/constants.dart';

class EmailService {
  void sendEmail(String email, String id, String nameProject,
      String displayName,MetaUserModel checkEmail) async {
    var name = AppStrings.hiMail +
        displayName +
        AppStrings.nameMail +
        nameProject +
        " project";
    var message = AppStrings.noAccountMessage;
    var messageLink = AppStrings.messageLinkRegister + "/$id";

    if (checkEmail.email != "") {
      message = AppStrings.alreadyAccountMessage;
      messageLink =
          AppStrings.messageLinkAccepted + "/${checkEmail.uid}" + "/$id";
    }
    await this.formatEmail(
        name: name,
        email: email,
        subject: AppStrings.subject,
        message: message,
        messageLink: messageLink);
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
}
