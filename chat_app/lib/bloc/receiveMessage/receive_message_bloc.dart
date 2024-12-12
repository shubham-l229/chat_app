import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/injection/dependency_injection.dart';
import 'package:chat_app/data/models/message_model.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../data/local/cache_manager.dart';
import '../../data/repositories/message_repositories.dart';

part 'receive_message_event.dart';
part 'receive_message_state.dart';

class ReceiveMessageBloc
    extends Bloc<ReceiveMessageEvent, ReceiveMessageState> {
  List<MessageModel> messageData = [];
  ScrollController scrollController = new ScrollController();

  ReceiveMessageBloc() : super(ReceiveMessageInitial()) {
    on<ReceiveMessage>(_receiveMessage);
    on<AddMessage>(_addMeassage);
  }
  final MessageRepositories _messageRepositories = MessageRepositories();

  FutureOr<void> _receiveMessage(
      ReceiveMessage event, Emitter<ReceiveMessageState> emit) async {
    emit(ReceiverMessageLoading());
    var sendMessageModel =
        await _messageRepositories.getMessage(event.receiverId);
    if (sendMessageModel != null) {
      messageData = sendMessageModel;
      getIt<SocketServices>().socket!.on("newMessage", (data) {
        MessageModel messageModel = MessageModel.fromJson(data);
        if (messageModel.senderId != getIt<CacheManager>().getUserId()) {
          add(AddMessage(messageModel: messageModel));
        }
      });

      emit(ReceiverMessageSuccess(messageModel: sendMessageModel));
    } else {
      emit(ReceiverMessageFailed());
    }
  }

  FutureOr<void> _addMeassage(
      AddMessage event, Emitter<ReceiveMessageState> emit) async {
    print("Andar aa gya");
    if (state is ReceiverMessageSuccess) {
      print(event.messageModel);
      messageData.add(event.messageModel);
      print(messageData);
      emit(ReceiverMessageSuccess(messageModel: messageData));
    }
  }
}
