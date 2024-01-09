import 'dart:convert';

import 'package:devil/models/study.dart';
import 'package:devil/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class StudyAPI extends API {
  const StudyAPI();

  String get url => dotenv.get('API_STUDY');
  String get join_url => dotenv.get('API_STUDY_JOIN');

  Future<List<Study>> getList() async {
    final response = await request(url, HttpMethod.get);

    if (response.statusCode.isOk()) {
      return (jsonDecode(response.body) as List)
          .map((e) => Study.fromJson(e))
          .toList();
    }
    return List.empty();
  }

  Future<bool> addStudy(Study study, String userid) async {
    final response = await request(
      url,
      HttpMethod.post,
      body: {
        'name': study.name,
        'category': study.category,
        'description': study.description,
        'max': study.max.toString(),
        'creatorid': userid,
      },
    ).timeout(const Duration(seconds: 3), onTimeout: () {
      return Response("Timeout", 408);
    });

    return response.statusCode.isOk();
  }

  Future joinStudy(String userid, int studyid) async {
    final response = await request(
      url,
      HttpMethod.post,
      body: {
        'userid': userid,
        'studyid': studyid,
      },
    ).timeout(const Duration(seconds: 3), onTimeout: () {
      return Response("Timeout", 408);
    });

    return response.statusCode.isOk();
  }
}
