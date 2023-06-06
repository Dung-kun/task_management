import 'package:flutter/material.dart';

import '../../util/extension/dimens.dart';
import '/base/base_state.dart';
import '/constants/constants.dart';
import '/pages/welcome/welcome_provider.dart';
import '/pages/welcome/welcome_vm.dart';

class WelcomePage extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return WelcomePage._(watch);
    });
  }

  const WelcomePage._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends BaseState<WelcomePage, WelcomeViewModel> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.white,
      width: screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  @override
  WelcomeViewModel getVm() => widget.watch(viewModelProvider).state;
}
