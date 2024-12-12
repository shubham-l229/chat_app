import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.message,
    required this.accepted,
    required this.iv,
    required this.moneyAcceptedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @JsonKey(name: '_id')
  final String? id;
  static const String idKey = "_id";

  final String? senderId;
  static const String senderIdKey = "senderId";

  final String? receiverId;
  static const String receiverIdKey = "receiverId";

  final String? type;
  static const String typeKey = "type";

  final String? message;
  static const String messageKey = "message";

  final bool? accepted;
  static const String acceptedKey = "accepted";

  final String? iv;
  static const String ivKey = "iv";

  final DateTime? moneyAcceptedAt;
  static const String moneyAcceptedAtKey = "moneyAcceptedAt";

  final DateTime? createdAt;
  static const String createdAtKey = "createdAt";

  final DateTime? updatedAt;
  static const String updatedAtKey = "updatedAt";

  @JsonKey(name: '__v')
  final num? v;
  static const String vKey = "__v";

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? type,
    String? message,
    bool? accepted,
    String? iv,
    DateTime? moneyAcceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? v,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      message: message ?? this.message,
      accepted: accepted ?? this.accepted,
      iv: iv ?? this.iv,
      moneyAcceptedAt: moneyAcceptedAt ?? this.moneyAcceptedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  String toString() {
    return "$id, $senderId, $receiverId, $type, $message, $accepted, $iv, $moneyAcceptedAt, $createdAt, $updatedAt, $v, ";
  }
}
