import 'package:devil/services/login.dart';

class User {
  final String id;
  final LoginPlatform platform;
  final String displayName;
  final String profileUrl;

  User({
    required this.id,
    required this.platform,
    required this.displayName,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      platform: LoginPlatform.byName(json['platform']),
      displayName: json['username'],
      profileUrl: json['profileUrl'] ?? '',
    );
  }
}
