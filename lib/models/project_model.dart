import 'package:equatable/equatable.dart';

import '/base/base_state.dart';

class ProjectModel extends Equatable {
  final String id;
  final String name;
  final String idAuthor;
  final int indexColor;
  final DateTime timeCreate;
  final List<String> listTask;

  ProjectModel({
    this.id = '',
    required this.name,
    required this.idAuthor,
    required this.indexColor,
    required this.listTask,
    required this.timeCreate,
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

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'id_author': this.idAuthor,
        'index_color': this.indexColor,
        'time_create':
            DateFormat("yyyy-MM-dd hh:mm:ss").format(this.timeCreate),
      };

  Map<String, dynamic> toFirestore() => {
        'name': this.name,
        'id_author': this.idAuthor,
        'index_color': this.indexColor,
        'time_create':
            DateFormat("yyyy-MM-dd hh:mm:ss").format(this.timeCreate),
        "list_task": this.listTask,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
