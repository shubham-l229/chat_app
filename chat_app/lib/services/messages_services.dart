import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/networks/dio_simple.dart';

class MessageServices {
  DioNetwork dioNetwork = DioNetwork();
  final String _messages = dotenv.env['MESSAGES']!;
  final String _sendMessages = dotenv.env['SEND_MESSAGES']!;
  final String _acceptMoney = dotenv.env['ACCEPT_MONEY']!;
  Future<dynamic> sendMessage(String receiverId, String message, String iv,
      String type, String dateTime) async {
    var data = {
      "message": message,
      "iv": iv,
      "type": type,
      "dateTime": dateTime
    };
    try {
      Response response = await dioNetwork
          .postData(_messages + _sendMessages + receiverId, data: data);

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<dynamic> getMessage(String receiverId) async {
    try {
      Response response = await dioNetwork.postData(_messages + receiverId);
      log(response.data.toString());

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<dynamic> acceptMoney(String messageId) async {
    try {
      Response response =
          await dioNetwork.getData(_messages + _acceptMoney + messageId);
      log(response.data.toString());

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
