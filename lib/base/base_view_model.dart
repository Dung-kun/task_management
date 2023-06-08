import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_do_list/providers/auth_provider.dart';
import 'package:to_do_list/services/auth_services.dart';
import 'package:to_do_list/services/fire_store_services.dart';

export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:rxdart/rxdart.dart';

abstract class BaseViewModel {
  BehaviorSubject<bool> bsLoading = new BehaviorSubject.seeded(false);
  BehaviorSubject<bool> bsRunning = new BehaviorSubject.seeded(false);

  final AutoDisposeProviderReference ref;
  late final AuthenticationService auth;
  late final FirestoreService firestoreService;

  User? user;

  BaseViewModel(this.ref) {
    auth = ref.watch(authServicesProvider);
    user = auth.currentUser();
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
