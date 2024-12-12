part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageEvent {}

class SendMessage extends SendMessageEvent {
  final String receiverId;
  final String message;
  final String type;
  final String? dateTime;
  final ReceiveMessageBloc receiveMessageBloc;

  SendMessage(
      {required this.receiverId,
      required this.message,
      required this.receiveMessageBloc,
      required this.type,
      required this.dateTime});
}
