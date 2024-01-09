import 'package:devil/models/study.dart';
import 'package:devil/models/user.dart';
import 'package:devil/services/api.dart';
import 'package:devil/services/login.dart';
import 'package:flutter/foundation.dart';

class InfoModel extends ChangeNotifier {
  bool _isLogined = false;
  bool get isLogined => _isLogined;

  late User _user;
  User get user => _user;

  late Future<List<Study>> _myStudies;
  Future<List<Study>> get myStudies => _myStudies;

  Future<bool> login(LoginPlatform platform) async {
    try {
      _user = (await API.auth.login(platform))!;
      _isLogined = true;
      getMyStudies();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> getMyStudies() async {
    _myStudies = API.study.getMyStudyList(_user.id);
  }

  void logout() {
    _user.platform.service.logout();
    _isLogined = false;
    notifyListeners();
  }
}
