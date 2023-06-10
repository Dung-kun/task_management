import 'package:to_do_list/models/project_model.dart';
import 'package:to_do_list/services/firestore_messing_service.dart';

import '/base/base_view_model.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(ref) : super(ref);

  void initMessingToken() {
    firestoreMessagingService.getToken();
  }

  void initMessagingChannel() {}

  void logOut() {
    auth.signOut();
  }

  void addProject(String name, int indexColor) {
    var temp = new ProjectModel(
      name: name,
      idAuthor: user!.uid,
      indexColor: indexColor,
      timeCreate: DateTime.now(),
      listTask: [],
    );
    firestoreService.addProject(temp);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
