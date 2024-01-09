import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter/services.dart';

enum LoginPlatform {
  google("Google", GoogleLoginService()),
  kakao("카카오", KakaoLoginService());

  const LoginPlatform(this.locale, this.service);
  final String locale;
  final LoginService service;

  factory LoginPlatform.byName(String name) =>
      LoginPlatform.values.singleWhere((e) => e.name == name);
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

class KakaoLoginService extends LoginService {
  const KakaoLoginService();

  static const LoginPlatform _platform = LoginPlatform.kakao;

  @override
  LoginPlatform get platform => _platform;

  Future<String?> _loginWithKakaoAccount() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      return token.accessToken;
    } catch (error) {
      debugPrint('Kakao login error: $error');
    }
    return null;
  }

  @override
  Future<String?> login() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          debugPrint("platformException");
        }
        return _loginWithKakaoAccount();
      }
    } else {
      return _loginWithKakaoAccount();
    }
    return null;
  }

  @override
  Future<void> logout() async {}
}

abstract class LoginService {
  const LoginService();

  LoginPlatform get platform;

  Future<String?> login();

  Future<void> logout();
}
