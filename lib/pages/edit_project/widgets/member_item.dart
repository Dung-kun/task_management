import 'package:flutter/material.dart';

import '/models/meta_user_model.dart';
import '/util/extension/extension.dart';
import '/util/ui/common_widget/custom_avatar_loading_image.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({
    Key? key,
    required this.userModel,
    required this.press,
  }) : super(key: key);

  final MetaUserModel userModel;

  final Function press;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:  MainAxisAlignment.start,
      children: [
        CustomAvatarLoadingImage(
          url: userModel.url ?? '',
          imageSize: 40,
        ),
        SizedBox(width: 10.w),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userModel.displayName.text14(),
              userModel.email.text12(),
            ],
          ),
        ),
        Icon(
            Icons.delete,
            color: Colors.redAccent,
          ).inkTap(
            onTap: () => press(),
            borderRadius: BorderRadius.circular(5),
          ),
      ],
    ).pad(0, 16);
  }
}
