import 'package:meta/meta.dart';

@immutable
class User {
  final String id;
  final String username;
  final String password;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime lastActive;

  const User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    this.avatar,
    required this.createdAt,
    required this.lastActive,
  });

  // Tạo từ JSON (nếu cần)
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    username: json['username'] as String,
    password: json['password'] as String,
    email: json['email'] as String,
    avatar: json['avatar'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastActive: DateTime.parse(json['lastActive'] as String),
  );

  // Chuyển về JSON (nếu cần)
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'password': password,
    'email': email,
    'avatar': avatar,
    'createdAt': createdAt.toIso8601String(),
    'lastActive': lastActive.toIso8601String(),
  };

  // copyWith để dễ clone khi update
  User copyWith({
    String? id,
    String? username,
    String? password,
    String? email,
    String? avatar,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}