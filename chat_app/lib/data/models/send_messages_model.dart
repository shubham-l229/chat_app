import 'package:json_annotation/json_annotation.dart';

part 'send_messages_model.g.dart';

@JsonSerializable()
class SendMessageModel {
  SendMessageModel({
    required this.message,
    required this.isOtpSent,
  });

  final Message? message;
  static const String messageKey = "message";

  final bool? isOtpSent;
  static const String isOtpSentKey = "isOtpSent";

  SendMessageModel copyWith({
    Message? message,
    bool? isOtpSent,
  }) {
    return SendMessageModel(
      message: message ?? this.message,
      isOtpSent: isOtpSent ?? this.isOtpSent,
    );
  }

  factory SendMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageModelToJson(this);

  @override
  String toString() {
    return "$message, $isOtpSent, ";
  }
}

@JsonSerializable()
class Message {
  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.iv,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? senderId;
  static const String senderIdKey = "senderId";

  final String? receiverId;
  static const String receiverIdKey = "receiverId";

  final String? message;
  static const String messageKey = "message";

  final String? iv;
  static const String ivKey = "iv";

  @JsonKey(name: '_id')
  final String? id;
  static const String idKey = "_id";

  final DateTime? createdAt;
  static const String createdAtKey = "createdAt";

  final DateTime? updatedAt;
  static const String updatedAtKey = "updatedAt";

  @JsonKey(name: '__v')
  final int? v;
  static const String vKey = "__v";

  Message copyWith({
    String? senderId,
    String? receiverId,
    String? message,
    String? iv,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      id: id ?? this.id,
      iv: iv ?? this.iv,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return "$senderId, $receiverId, $message,$iv, $id, $createdAt, $updatedAt, $v, ";
  }
}
