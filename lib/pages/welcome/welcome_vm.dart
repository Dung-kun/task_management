import '/base/base_view_model.dart';

class WelcomeViewModel extends BaseViewModel {
  WelcomeViewModel(AutoDisposeProviderReference ref) : super(ref);


  @override
  void dispose() {
  }
}

enum InitialStatus { onBoarding, home, loading, error }
