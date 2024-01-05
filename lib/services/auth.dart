import 'package:devil/services/api.dart';
import 'package:devil/services/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthAPI extends API {
  const AuthAPI();

  Future<void> login(LoginPlatform platform) async {
    final token = await platform.service.login();
    final url = dotenv.get('API_AUTH');

    final response = await request(
      '$url/${platform.name}',
      HttpMethod.post,
      body: {'token': token},
    );

    print("tried to post token($token) to server");
    print('${response.statusCode}: ${response.body}');
  }
}
