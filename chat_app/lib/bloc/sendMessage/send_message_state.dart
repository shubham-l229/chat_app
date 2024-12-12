part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageSuccess extends SendMessageState{
  final SendMessageModel sendMessageModel;

  SendMessageSuccess({required this.sendMessageModel});
}
class SendMessageFailed extends SendMessageState{}
class SendMessageLoading extends SendMessageState{}