import 'package:devil/models/study.dart';
import 'package:devil/services/api.dart';
import 'package:flutter/foundation.dart';

enum StudyCategory {
  frontend("Frontend"),
  backend("Backend"),
  app("App"),
  etc("etc");

  const StudyCategory(this.locale);

  final String locale;
}

class StudyModel extends ChangeNotifier {
  late Future<List<Study>> _studies;
  Future<List<Study>> get studies => _studies;

  StudyModel() {
    getStudies();
  }

  Future<void> getStudies() async {
    _studies = API.study.getList();
    notifyListeners();
  }

  Future<bool> addStudy(Study study, String userid) async {
    final isAdded = await API.study.addStudy(study, userid);
    return isAdded;
  }

  Future joinStudy(String userid, int studyid) async {
    final joinstudy = await API.study.joinStudy(userid, studyid);
    return joinstudy;
  }
}
