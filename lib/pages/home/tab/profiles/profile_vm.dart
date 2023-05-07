import 'package:firebase_auth/firebase_auth.dart';
import '/models/task_model.dart';
import '/base/base_view_model.dart';
import '/models/quick_note_model.dart';

class ProfileViewModel extends BaseViewModel {
  BehaviorSubject<infoStatus> bsInfoStatus =
      BehaviorSubject.seeded(infoStatus.info);

  BehaviorSubject<List<TaskModel>?> bsListTask =
      BehaviorSubject<List<TaskModel>>();

  BehaviorSubject<List<QuickNoteModel>?> bsListQuickNote =
      BehaviorSubject<List<QuickNoteModel>>();

  ProfileViewModel(ref) : super(ref) {}

  void uploadAvatar(String filePath) async {
    bsInfoStatus.add(infoStatus.info);
  }

  void changeInfoStatus(infoStatus status) {
    bsInfoStatus.add(status);
  }

  @override
  void dispose() {
    bsListQuickNote.close();
    bsListTask.close();
    bsInfoStatus.close();
    super.dispose();
  }
}

enum infoStatus { info, setting }
