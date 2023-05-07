import '/base/base_view_model.dart';
import '/models/quick_note_model.dart';

class MyNoteViewModel extends BaseViewModel {
  BehaviorSubject<List<QuickNoteModel>?> bsListQuickNote =
      BehaviorSubject<List<QuickNoteModel>>();

  MyNoteViewModel(ref) : super(ref) {}

  void successfulQuickNote(QuickNoteModel quickNoteModel) {
    // update to local
    quickNoteModel.isSuccessful = true;
    // update to network
  }

  void checkedNote(QuickNoteModel quickNoteModel, int idNote) {
    // check note
    quickNoteModel.listNote[idNote].check = true;
    // update note to network
  }

  void deleteNote(QuickNoteModel quickNoteModel) async {}

  @override
  void dispose() {
    super.dispose();
  }
}
