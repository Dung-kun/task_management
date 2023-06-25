import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:to_do_list/routing/app_routes.dart';

import '/constants/constants.dart';
import '/models/task_model.dart';
import '/util/extension/extension.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, required this.task, this.press})
      : super(key: key);

  final Function? press;
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.KBoxShadowCard,
            offset: Offset(5, 5),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
            height: 10.w,
            child: SvgPicture.asset(
              task.completed
                  ? AppImages.checkTrueIcon
                  : AppImages.checkFalseIcon,
            ),
          ).pad(25, 23, 27, 27),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                task.title
                    .plain()
                    .fSize(18)
                    .lines(1)
                    .overflow(TextOverflow.ellipsis)
                    .weight(FontWeight.w600)
                    .b(),
                SizedBox(height: 4.w),
                toTimeString(task.dueDate)
                    .plain()
                    .fSize(16)
                    .weight(FontWeight.w500)
                    .color(AppColors.kGrayTextA)
                    .b()
              ],
            ),
          ),
          (press == null)
              ? Container(
                  width: 4.w,
                  height: 21.w,
                  color: task.completed
                      ? AppColors.kPrimaryColor
                      : AppColors.kColorNote[0],
                ).pad(10, 0, 0)
              : Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                )
        ],
      ),
    )
        .inkTap(
            onTap: () => Get.toNamed(AppRoutes.DETAIL_TASK, arguments: task.id))
        .pad(8, 16);
  }

  String toTimeString(DateTime dateTime) {
    String result = '';
    result +=
        (dateTime.hour % 12).toString() + ':' + dateTime.minute.toString();
    if (dateTime.hour > 12)
      result += 'pm';
    else
      result += 'am';
    return result;
  }
}
