import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_do_list/services/firestore_messing_service.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:rxdart/rxdart.dart';


abstract class BaseViewModel {
  BehaviorSubject<bool> bsLoading = new BehaviorSubject.seeded(false);
  BehaviorSubject<bool> bsRunning = new BehaviorSubject.seeded(false);

  final AutoDisposeProviderReference ref;
  late final FirestoreMessagingService firestoreMessagingService;
  User? user;

  BaseViewModel(this.ref) {
  }

  @mustCallSuper
  void dispose() {
    bsRunning.close();
    bsLoading.close();
  }

  showLoading() => bsLoading.add(true);

  closeLoading() => bsLoading.add(false);

  startRunning() => bsRunning.add(true);

  endRunning() => bsRunning.add(false);
}
