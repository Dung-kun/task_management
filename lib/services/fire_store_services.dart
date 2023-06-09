import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:to_do_list/models/meta_user_model.dart';

import '/constants/app_colors.dart';
import '/models/project_model.dart';
import '/models/quick_note_model.dart';
import '/models/task_model.dart';
import '../models/comment_model.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreService(this._firebaseFirestore);

  Stream<List<ProjectModel>> projectStream(String uid) {
    return _firebaseFirestore
        .collection('project')
        .where('list_member', arrayContains: uid)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) {
            return ProjectModel.fromFirestore(doc);
          }).toList(),
        );
  }

  Future<void> updateProject(
      String uid, String name, List<String> member, List<String> task) async {
    await _firebaseFirestore.collection('project').doc(uid).update({
      'name': name,
      'list_member': member,
      'list_task': task
    }).then((value) {
      servicesResultPrint('Update project successful', isToast: false);
    });
  }

  Stream<List<ProjectModel>> projectStreamWithListMember(String uid) {
    return _firebaseFirestore
        .collection('project')
        .where('list_member', arrayContains: uid)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) {
            return ProjectModel.fromFirestore(doc);
          }).toList(),
        );
  }

  Stream<List<TaskModel>> taskStream() {
    return _firebaseFirestore.collection('task').snapshots().map(
          (list) => list.docs.map((doc) {
            return TaskModel.fromFirestore(doc);
          }).toList(),
        );
  }

  Stream<List<CommentModel>> commentStream(String taskId) {
    return _firebaseFirestore
        .collection('task')
        .doc(taskId)
        .collection('comment')
        .snapshots()
        .map(
          (list) => list.docs.map((doc) {
            return CommentModel.fromFirestore(doc);
          }).toList(),
        );
  }

  Stream<TaskModel> taskStreamById(String id) {
    return _firebaseFirestore
        .collection('task')
        .doc(id)
        .snapshots()
        .map((doc) => TaskModel.fromFirestore(doc));
  }

  Future<TaskModel> getTaskById(String id) {
    return _firebaseFirestore
        .collection('task')
        .doc(id)
        .get()
        .then((doc) => TaskModel.fromFirestore(doc));
  }

  Stream<MetaUserModel> userStreamById(String id) {
    return _firebaseFirestore
        .collection('user')
        .doc(id)
        .snapshots()
        .map((doc) => MetaUserModel.fromFirestore(doc));
  }

  Future<MetaUserModel> getUserById(String id) {
    return _firebaseFirestore
        .collection('user')
        .doc(id)
        .get()
        .then((doc) => MetaUserModel.fromFirestore(doc));
  }

  Future<MetaUserModel> getUserByEmail(String email) {
    return _firebaseFirestore
        .collection('user')
        .where("email", isEqualTo: email)
        .limit(1)
        .get()
        .then((doc) => (doc.size > 0)
            ? MetaUserModel.fromFirestore(doc.docs.first)
            : MetaUserModel(email: "", displayName: ""));
  }

  Future<ProjectModel> getProjectById(String id) {
    return _firebaseFirestore
        .collection('project')
        .doc(id)
        .get()
        .then((doc) => ProjectModel.fromFirestore(doc));
  }

  Stream<ProjectModel> projectStreamById(String id) {
    return _firebaseFirestore
        .collection('project')
        .doc(id)
        .snapshots()
        .map((doc) => ProjectModel.fromFirestore(doc));
  }

  Stream<List<MetaUserModel>> userStream(String email) {
    return _firebaseFirestore
        .collection('user')
        .where('email', isNotEqualTo: email)
        .snapshots()
        .map(
          (list) => list.docs.map((doc) {
            return MetaUserModel.fromFirestore(doc);
          }).toList(),
        );
  }

  DocumentReference getDoc(String collectionPath, String id) {
    return _firebaseFirestore.collection(collectionPath).doc(id);
  }

  Future<MetaUserModel> getMetaUserByIDoc(DocumentReference doc) {
    return doc.get().then((value) => MetaUserModel.fromFirestore(value));
  }

  Future<ProjectModel> getProject(DocumentReference doc) {
    return doc.get().then((value) => ProjectModel.fromFirestore(value));
  }

  Future<bool> deleteQuickNote(String uid, String id) async {
    await _firebaseFirestore
        .collection('user')
        .doc(uid)
        .collection('quick_note')
        .doc(id)
        .delete()
        .then((value) {
      servicesResultPrint("Quick note Deleted");
      return true;
    }).catchError((error) {
      servicesResultPrint("Failed to delete quick note: $error");
      return false;
    });
    return false;
  }

  void addProject(ProjectModel project, String uuid) {
    _firebaseFirestore
        .collection('project')
        .doc(uuid)
        .set(project.toFirestore())
        .catchError(
            (e) => servicesResultPrint("An error occurred, please try again"));
  }

  void deleteProject(ProjectModel project) {
    _firebaseFirestore
        .collection('project')
        .doc(project.id)
        .delete()
        .then((value) {
      servicesResultPrint("Project Deleted");
    }).catchError((error) {
      servicesResultPrint("Failed to delete project: $error");
    });
  }

  Future<bool> addTaskProject(ProjectModel projectModel, String taskID) async {
    List<String> list = projectModel.listTask;
    list.add(taskID);

    await _firebaseFirestore.collection('project').doc(projectModel.id).update({
      "list_task": list,
    }).then((value) {
      servicesResultPrint('Added task to project');
      return true;
    }).catchError((error) {
      servicesResultPrint('Add task to project failed: $error');
      return false;
    });
    return true;
  }

  Future<bool> deleteTaskProject(
      ProjectModel projectModel, String taskID) async {
    List<String> list = projectModel.listTask;
    list.remove(taskID);

    await _firebaseFirestore.collection('project').doc(projectModel.id).update({
      "list_task": list,
    }).then((value) {
      servicesResultPrint('Delete task to project');
      return true;
    }).catchError((error) {
      servicesResultPrint('Delete task to project failed: $error');
      return false;
    });
    return true;
  }

  Future<void> completedTaskById(String id) async {
    await _firebaseFirestore
        .collection('task')
        .doc(id)
        .update({"completed": true}).then((value) {
      servicesResultPrint('Completed Task');
    }).catchError((error) {
      servicesResultPrint('Completed Task failed: $error');
    });
  }

  Future<void> updateDescriptionUrlTaskById(String id, String url) async {
    await _firebaseFirestore
        .collection('task')
        .doc(id)
        .update({"des_url": url}).then((value) {
      servicesResultPrint('Update url successful');
    }).catchError((error) {
      servicesResultPrint('Update url failed: $error');
    });
  }

  Future<void> updateDescriptionUrlCommentById(
      String taskId, String commentId, String url) async {
    await _firebaseFirestore
        .collection('task')
        .doc(taskId)
        .collection('comment')
        .doc(commentId)
        .update({"url": url}).then((value) {
      servicesResultPrint('Update url successful');
    }).catchError((error) {
      servicesResultPrint('Update url failed: $error');
    });
  }

  Future<void> createUserData(
      String uid, String displayName, String email) async {
    await _firebaseFirestore.collection('user').doc(uid).set({
      'display_name': displayName,
      'email': email,
    }).then((value) {
      servicesResultPrint('Create user data successful', isToast: false);
    });
  }

  Future<void> updateUserAvatar(String uid, String url) async {
    await _firebaseFirestore.collection('user').doc(uid).update({
      'url': url,
    }).then((value) {
      servicesResultPrint('Update avatar successful', isToast: false);
    });
  }

  Future<String> addTask(TaskModel task) async {
    DocumentReference doc = _firebaseFirestore.collection('task').doc();
    await doc.set(task.toFirestore()).then((onValue) {
      servicesResultPrint('Added task');
    }).catchError((error) {
      servicesResultPrint('Add task failed: $error');
    });
    return doc.id;
  }

  Future<String> addComment(CommentModel comment, String taskId) async {
    DocumentReference doc = _firebaseFirestore
        .collection('task')
        .doc(taskId)
        .collection('comment')
        .doc();
    await doc.set(comment.toFirestore()).then((onValue) {
      servicesResultPrint('Added comment');
    }).catchError((error) {
      servicesResultPrint('Add comment failed: $error');
    });
    return doc.id;
  }

  Future<bool> deleteTask(String id) async {
    await _firebaseFirestore.collection('task').doc(id).delete().then((value) {
      servicesResultPrint("Task Deleted");
      return true;
    }).catchError((error) {
      servicesResultPrint("Failed to delete task: $error");
      return false;
    });
    return false;
  }

  Future<bool> updateTask(TaskModel task) async {
    await _firebaseFirestore
        .collection('task')
        .doc(task.id)
        .set(task.toFirestore())
        .then((value) {
          print("buon vccc");
      servicesResultPrint("Task updated");
      return true;
    }).catchError((onError) {
      servicesResultPrint("Failed to update task: $onError");
      return false;
    });
    return false;
  }

  Future<void> updateTaskById(String id, List<String> mem) async {
    await _firebaseFirestore
        .collection('task')
        .doc(id)
        .update({"list_member": mem})
        .then((value) => servicesResultPrint("Task updated"))
        .catchError((onError) =>
            servicesResultPrint("Failed to update task: $onError"));
  }

  void servicesResultPrint(String result, {bool isToast = true}) async {
    print("FirebaseStore services result: $result");

    if (isToast)
      await Fluttertoast.showToast(
        msg: result,
        timeInSecForIosWeb: 2,
        backgroundColor: AppColors.kWhiteBackground,
        textColor: AppColors.kText,
      );
  }

  Stream<List<QuickNoteModel>> quickNoteStream(String uid) {
    return _firebaseFirestore
        .collection('user')
        .doc(uid)
        .collection('quick_note')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (list) => list.docs
              .map((doc) => QuickNoteModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<bool> addQuickNote(String uid, QuickNoteModel quickNote) async {
    await _firebaseFirestore
        .collection('user')
        .doc(uid)
        .collection('quick_note')
        .doc()
        .set(quickNote.toFirestore())
        .then((_) {
      servicesResultPrint('Added quick note');

      return true;
    }).catchError((error) {
      servicesResultPrint('Add quick note failed: $error');
      return false;
    });
    return false;
  }

  Future<bool> updateQuickNote(
      String uid, QuickNoteModel quickNoteModel) async {
    await _firebaseFirestore
        .collection('user')
        .doc(uid)
        .collection('quick_note')
        .doc(quickNoteModel.id)
        .set(quickNoteModel.toFirestore())
        .then((value) {
      servicesResultPrint("Quick note updated");
      return true;
    }).catchError((onError) {
      servicesResultPrint("Failed to update quick note: $onError");
      return false;
    });
    return false;
  }

  Stream<List<QuickNoteModel>> taskNoteStream(String uid) {
    return _firebaseFirestore
        .collection('task')
        .doc(uid)
        .collection('task_note')
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (list) => list.docs
              .map((doc) => QuickNoteModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<bool> addTaskNote(String uid, QuickNoteModel quickNote) async {
    await _firebaseFirestore
        .collection('task')
        .doc(uid)
        .collection('task_note')
        .doc()
        .set(quickNote.toFirestore())
        .then((_) {
      servicesResultPrint('Added quick note');

      return true;
    }).catchError((error) {
      servicesResultPrint('Add quick note failed: $error');
      return false;
    });
    return false;
  }

  Future<bool> deleteTaskNote(String uid, String id) async {
    await _firebaseFirestore
        .collection('task')
        .doc(uid)
        .collection('task_note')
        .doc(id)
        .delete()
        .then((value) {
      servicesResultPrint("Quick note Deleted");
      return true;
    }).catchError((error) {
      servicesResultPrint("Failed to delete quick note: $error");
      return false;
    });
    return false;
  }

  Future<bool> updateTaskNote(String uid, QuickNoteModel quickNoteModel) async {
    await _firebaseFirestore
        .collection('task')
        .doc(uid)
        .collection('task_note')
        .doc(quickNoteModel.id)
        .set(quickNoteModel.toFirestore())
        .then((value) {
      servicesResultPrint("Quick note updated");
      return true;
    }).catchError((onError) {
      servicesResultPrint("Failed to update quick note: $onError");
      return false;
    });
    return false;
  }
}
