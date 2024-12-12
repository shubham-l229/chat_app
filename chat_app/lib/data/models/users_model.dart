import 'package:json_annotation/json_annotation.dart';

part 'users_model.g.dart';

@JsonSerializable()
class UsersModel {
  UsersModel({
    required this.message,
    required this.users,
    required this.isSuccesfull,
  });

  final String? message;
  final List<User>? users;
  final bool? isSuccesfull;

  UsersModel copyWith({
    String? message,
    List<User>? users,
    bool? isSuccesfull,
  }) {
    return UsersModel(
      message: message ?? this.message,
      users: users ?? this.users,
      isSuccesfull: isSuccesfull ?? this.isSuccesfull,
    );
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) => _$UsersModelFromJson(json);

  Map<String, dynamic> toJson() => _$UsersModelToJson(this);

  @override
  String toString(){
    return "$message, $users, $isSuccesfull, ";
  }
}

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @JsonKey(name: '__v')
  final int? v;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString(){
    return "$id, $name, $email, $phone, $profileImageUrl, $createdAt, $updatedAt, $v, ";
  }
}
