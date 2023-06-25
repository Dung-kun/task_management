import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:to_do_list/constants/app_colors.dart';
import 'package:to_do_list/constants/constants.dart';
import 'package:to_do_list/models/project_model.dart';
import 'package:to_do_list/util/extension/dimens.dart';
import 'package:to_do_list/util/extension/widget_extension.dart';

import '../../../routing/app_routes.dart';

class ProjectCard extends StatelessWidget {

  const ProjectCard({
    Key? key,
    required this.project,
    required this.press,
    required this.deletePress,
    required this.identify
  }) : super(key: key);

  final ProjectModel project;
  final Function press;
  final Function deletePress;
  final String identify;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      height: 180.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(5, 10),
            color: Color(0xFFE0DEDE).withOpacity(.5),
            blurRadius: 5.r,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                        color: AppColors.kColorNote[project.indexColor]
                            .withOpacity(.3),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: AppColors.kColorNote[project.indexColor],
                            shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                if(project.idAuthor == identify) Icon(
                  Icons.edit,
                  color: Colors.redAccent,
                ).inkTap(
                    onTap: () => Get.toNamed(AppRoutes.EDIT_PROJECT, arguments: project.id),
                    borderRadius: BorderRadius.circular(5)),
                if(project.idAuthor == identify) SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ).inkTap(
                    onTap: () => deletePress(project),
                    borderRadius: BorderRadius.circular(5)),
              ],
            ),
            Spacer(),
            Text(
              project.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Text("${project.listTask.length} Task")
          ],
        ),
      ),
    ).inkTap(
      onTap: () => press(project),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
