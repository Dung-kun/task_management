import 'package:riverpod/riverpod.dart';
import 'package:to_do_list/pages/edit_project/edit_project_vm.dart';


final viewModelProvider = StateProvider.autoDispose<EditProjectViewModel>(
      (ref) {
    var vm = EditProjectViewModel(ref);
    ref.onDispose(() {
      vm.dispose();
    });
    return vm;
  },
);