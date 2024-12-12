class ChatModel {
  String message;
  String sender;
  ChatModel({required this.message, required this.sender});
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'],
      sender: json['sender'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sender': sender,
    };
  }
}
