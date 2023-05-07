import 'package:flutter/material.dart';

import '/base/base_state.dart';
import '/constants/strings.dart';
import '/routing/app_routes.dart';
import 'sign_in_provider.dart';
import 'sign_in_vm.dart';

class SignInPage extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return SignInPage._(watch);
    });
  }

  const SignInPage._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends BaseState<SignInPage, SignInViewModel> {
  bool isHidden = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String signInStatusString = '';
  SignInStatus appStatus = SignInStatus.pause;

  final formKey = GlobalKey<FormState>();

  void togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  Future<void> signInClick() async {
    print(passwordController.text);
    if (formKey.currentState!.validate()) {
      getVm().login(emailController.text, passwordController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    getVm().bsLoginStatus.listen((status) {
      setState(() {
        appStatus = status;
      });
      switch (status) {
        case SignInStatus.networkError:
          setState(() {
            signInStatusString = AppStrings.networkError;
          });
          break;
        case SignInStatus.successful:
          Get.offAndToNamed(AppRoutes.HOME);
          break;
        case SignInStatus.userDisabled:
          setState(() {
            signInStatusString = AppStrings.userDisabled;
          });
          break;
        case SignInStatus.invalidEmail:
          setState(() {
            signInStatusString = AppStrings.invalidEmail;
          });
          break;
        case SignInStatus.userNotFound:
          setState(() {
            signInStatusString = AppStrings.userNotFound;
          });
          break;
        case SignInStatus.wrongPassword:
          setState(() {
            signInStatusString = AppStrings.wrongPassword;
          });
          break;
        default:
          setState(() {
            signInStatusString = '';
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildForm(),
    );
  }

  Widget buildForm() => SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Container(),
      ));

  @override
  SignInViewModel getVm() => widget.watch(viewModelProvider).state;
}
