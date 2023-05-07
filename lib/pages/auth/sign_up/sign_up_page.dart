import 'package:flutter/material.dart';
import '../../../routing/app_routes.dart';
import '/base/base_state.dart';
import 'sign_up_provider.dart';
import 'sign_up_vm.dart';

class SignUpPage extends StatefulWidget {
  final ScopedReader watch;

  static Widget instance() {
    return Consumer(builder: (context, watch, _) {
      return SignUpPage._(watch);
    });
  }

  const SignUpPage._(this.watch);

  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends BaseState<SignUpPage, SignUpViewModel> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String signUpStatusString = '';

  Future<void> _checkSignUp() async {
    if (_formKey.currentState!.validate()) {
      getVm().signUp(_emailController.text, _passwordController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    getVm().bsSignUpStatus.listen((value) {
      switch (value) {
        case SignUpStatus.successfulEmail:
          getVm().createData(_emailController.text, _fullNameController.text);
          break;
        case SignUpStatus.successfulData:
          Get.offAndToNamed(AppRoutes.HOME);
          break;
        case SignUpStatus.emailAlreadyInUse:
          setState(() {
            signUpStatusString = '';
          });
          break;
        case SignUpStatus.invalidEmail:
          setState(() {
            // signUpStatusString = AppStrings.i
          });
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: buildForm(),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Container(),
    );
  }

  @override
  SignUpViewModel getVm() => widget.watch(viewModelProvider).state;
}
