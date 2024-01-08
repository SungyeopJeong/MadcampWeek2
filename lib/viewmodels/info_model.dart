import 'package:devil/models/user.dart';
import 'package:devil/services/api.dart';
import 'package:devil/services/login.dart';
import 'package:flutter/foundation.dart';

class InfoModel extends ChangeNotifier {
  bool _isLogined = false;
  bool get isLogined => _isLogined;
  late User _user;
  User get user => _user;

  Future<bool> login(LoginPlatform platform) async {
    try {
      _user = (await API.auth.login(platform))!;
      _isLogined = true;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void logout() {
    _user.platform.service.logout();
    _isLogined = false;
    notifyListeners();
  }
}
