part of 'receive_message_bloc.dart';

@immutable
abstract class ReceiveMessageEvent {}

class ReceiveMessage extends ReceiveMessageEvent{
  final String receiverId;

  ReceiveMessage({required this.receiverId});
}

class AddMessage extends ReceiveMessageEvent{
  final MessageModel messageModel;

  AddMessage({required this.messageModel});
}