part of 'receive_message_bloc.dart';

@immutable
abstract class ReceiveMessageState {}

class ReceiveMessageInitial extends ReceiveMessageState {}

class ReceiverMessageSuccess extends ReceiveMessageState{
  final List<MessageModel> messageModel;

  ReceiverMessageSuccess({required this.messageModel});
}
class ReceiverMessageFailed extends ReceiveMessageState{}
class ReceiverMessageLoading extends ReceiveMessageState{}