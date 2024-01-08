import 'package:devil/services/login.dart';

class User {
  final String id;
  final LoginPlatform platform;
  final String displayName;

  User({
    required this.id,
    required this.platform,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      platform: LoginPlatform.byName(json['platform']),
      displayName: json['username'],
    );
  }
}
