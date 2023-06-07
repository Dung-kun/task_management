import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/constants/app_colors.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  User? currentUser() {
    if (_firebaseAuth.currentUser == null) {
      servicesResultPrint('Current user not found', isToast: false);
      return null;
    }
    servicesResultPrint("Current user: ${_firebaseAuth.currentUser!.uid}",
        isToast: false);
    return _firebaseAuth.currentUser;
  }

  void servicesResultPrint(String result, {bool isToast = true}) async {
    print("FirebaseAuthentication services result: $result");
    if (isToast)
      await Fluttertoast.showToast(
        msg: result,
        timeInSecForIosWeb: 2,
        backgroundColor: AppColors.kWhiteBackground,
        textColor: AppColors.kText,
      );
  }
}
