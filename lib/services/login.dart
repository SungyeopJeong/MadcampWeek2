import 'package:google_sign_in/google_sign_in.dart';

enum LoginPlatform {
  google("Google", GoogleLoginService()),
  kakao("카카오", null);

  const LoginPlatform(this.locale, this.service);
  final String locale;
  final LoginService? service;
}

class GoogleLoginService extends LoginService {
  const GoogleLoginService();

  static const LoginPlatform _platform = LoginPlatform.google;

  @override
  LoginPlatform get platform => _platform;

  @override
  Future<String?> login() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();

    return (await user?.authentication)?.accessToken;
  }

  @override
  Future<void> logout() async {
    GoogleSignIn().signOut();
  }
}

abstract class LoginService {
  const LoginService();

  LoginPlatform get platform;

  Future<String?> login();

  Future<void> logout();
}