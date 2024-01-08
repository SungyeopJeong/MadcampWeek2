import 'dart:convert';

import 'package:devil/models/user.dart';
import 'package:devil/services/api.dart';
import 'package:devil/services/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class AuthAPI extends API {
  const AuthAPI();

  Future<User?> login(LoginPlatform platform) async {
    final token = await platform.service.login();
    final url = dotenv.get('API_AUTH');

    final response = await request(
      '$url/${platform.name}',
      HttpMethod.post,
      body: {'token': token},
    ).timeout(const Duration(seconds: 3), onTimeout: () {
      return Response("Timeout", 408);
    });

    if (response.statusCode.isOk()) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
