import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter/services.dart';

enum LoginPlatform {
  google("Google", GoogleLoginService()),
  kakao("카카오", KakaoLoginService());

  const LoginPlatform(this.locale, this.service);
  final String locale;
  final LoginService service;
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

  @override
  Future<String?> login() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          print("platformException");
        }
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          await UserApi.instance.loginWithKakaoAccount();
          final user = await UserApi.instance.me();
          print('User Name: ${user.kakaoAccount!.profile!.nickname}');
          print('token: $token');
          return token.accessToken;
        } catch (error) {
          print('Kakao login error: $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await UserApi.instance.loginWithKakaoAccount();
        final user = await UserApi.instance.me();
        print('User Name: ${user.kakaoAccount!.profile!.nickname}');
        print('token: $token');
        return token.accessToken;
      } catch (error) {
        print('Kakao login error: $error');
      }
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