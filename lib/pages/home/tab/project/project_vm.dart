import '/base/base_view_model.dart';
import '/models/project_model.dart';

class ProjectViewModel extends BaseViewModel {
  BehaviorSubject<List<ProjectModel>?> bsProject = BehaviorSubject();

  ProjectViewModel(ref) : super(ref) {}

  void addProject(String name, int indexColor) {
    var temp = new ProjectModel(
      name: name,
      idAuthor: user!.uid,
      indexColor: indexColor,
      timeCreate: DateTime.now(),
      listTask: [],
    );
  }

  void deleteProject(ProjectModel project) {}

  @override
  void dispose() {
    bsProject.close();
    super.dispose();
  }
}
