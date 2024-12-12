import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/data/models/send_messages_model.dart';
import 'package:chat_app/data/repositories/message_repositories.dart';
import 'package:meta/meta.dart';

import '../receiveMessage/receive_message_bloc.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  SendMessageBloc() : super(SendMessageInitial()) {
    on<SendMessage>(_sendMessage);
  }

  final MessageRepositories _messageRepositories = MessageRepositories();

  FutureOr<void> _sendMessage(
      SendMessage event, Emitter<SendMessageState> emit) async {
    var sendMessageModel = await _messageRepositories.sendMessage(
        event.receiverId, event.message, event.type, event.dateTime!);
    if (sendMessageModel != null) {
      SendMessageModel sendMessageModelNew = sendMessageModel;
      MessageModel messageModel =
          MessageModel.fromJson(sendMessageModelNew.message!.toJson());
      emit(SendMessageSuccess(sendMessageModel: sendMessageModel));
    } else {
      emit(SendMessageFailed());
    }
  }
}
