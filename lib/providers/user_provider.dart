import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/firebase/auth_repository.dart';

import '../model/user.dart';

class UserProvider with ChangeNotifier {
  AuthRepositoryProvide authRep = AuthRepositoryProvide();
  User? _user;

  User get getUser {
    return _user!;
  }

  Future<void> refreshUser() async {
    User? user = await authRep.getUserData();
    _user = user;
    notifyListeners();
  }
}
