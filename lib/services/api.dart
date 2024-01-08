import 'package:devil/services/auth.dart';
import 'package:devil/services/study.dart';
import 'package:http/http.dart';

enum HttpMethod {
  get,
  post;
}

extension StatusCode on int {
  bool isOk() {
    return this == 200 || this == 201;
  }
}

class API {
  const API();

  static const auth = AuthAPI();
  static const study = StudyAPI();

  Future<Response> request(
    String url,
    HttpMethod method, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    try {
      final headers = {if (token != null) 'Authorization': 'Bearer $token'};

      switch (method) {
        case HttpMethod.get:
          return await get(Uri.parse(url), headers: headers);
        case HttpMethod.post:
          return await post(Uri.parse(url), headers: headers, body: body);
      }
    } catch (e) {
      return Response('', 404);
    }
  }
}
