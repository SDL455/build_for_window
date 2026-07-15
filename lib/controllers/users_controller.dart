import 'package:get/get.dart';

import '../app/utils/helpers.dart';
import '../data/models/user_model.dart';
import '../services/firestore_service.dart';

/// Manage platform users (customers, merchants, riders).
class UsersController extends GetxController {
  final FirestoreService _firestoreService;

  UsersController(this._firestoreService);

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxString search = ''.obs;
  final RxString roleFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    _firestoreService.usersStream().listen((list) => users.value = list);
  }

  List<UserModel> get filtered {
    var list = users.toList();
    if (roleFilter.value != 'all') {
      list = list.where((u) => u.role == roleFilter.value).toList();
    }
    final q = search.value.toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((u) =>
              u.fullName.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  Future<void> remove(UserModel user) async {
    final ok = await Helpers.confirm(
      title: 'Delete user',
      message: 'Remove ${user.fullName}? This cannot be undone.',
    );
    if (!ok) return;
    final res = await _firestoreService.deleteUser(user.uid);
    res.fold((e) => Helpers.showError(e),
        (_) => Helpers.showSuccess('User removed'));
  }
}
