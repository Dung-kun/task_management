import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '/base/base_state.dart';

class ProjectModel extends Equatable {
  final String id;
  final String name;
  final String idAuthor;
  final int indexColor;
  final DateTime timeCreate;
  final List<String> listTask;
  final List<String> listMember;

  ProjectModel({
    this.id = '',
    required this.name,
    required this.idAuthor,
    required this.indexColor,
    required this.listTask,
    required this.timeCreate,
    required this.listMember,
  });

  // factory ProjectModel.fromJson(Map<String, dynamic> json) {
  //   return ProjectModel(
  //     id: json['id'],
  //     name: json['name'],
  //     idAuthor: json['id_author'],
  //     countTask: json['count_task'],
  //     indexColor: json['index_color'],
  //     timeCreate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
  //       json['time_create'],
  //     ),
  //   );
  // }

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    List<String> listTask = [];
    List<String> listMember = [];
    for (int i = 0; i < doc["list_task"].length; i++) {
      listTask.add(doc["list_task"][i]);
    }
    if(doc.data().toString().contains('list_member')) {
      for (int i = 0; i < doc["list_member"].length; i++) {
        listMember.add(doc["list_member"][i]);
      }
    }

    return ProjectModel(
        id: doc.id,
        name: doc['name'],
        idAuthor: doc['id_author'],
        indexColor: doc['index_color'],
        timeCreate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(
          doc['time_create'],
        ),
        listTask: listTask,
        listMember: listMember
    );
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'name': this.name,
    'id_author': this.idAuthor,
    'index_color': this.indexColor,
    'time_create':
    DateFormat("yyyy-MM-dd hh:mm:ss").format(this.timeCreate),
    'list_member': this.listMember
  };

  Map<String, dynamic> toFirestore() => {
    'name': this.name,
    'id_author': this.idAuthor,
    'index_color': this.indexColor,
    'time_create':
    DateFormat("yyyy-MM-dd hh:mm:ss").format(this.timeCreate),
    "list_task": this.listTask,
    'list_member': this.listMember
  };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
