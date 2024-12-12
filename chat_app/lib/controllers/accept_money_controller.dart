import 'dart:math';

import 'package:get/get.dart';

import '../services/messages_services.dart';
import 'package:dio/dio.dart' as d;

class AcceptMoneyController extends GetxController {
  RxBool isLoading = false.obs;
  MessageServices _messageServices = MessageServices();
  acceptMoney(String messageId) async {
    isLoading.value = true;

    bool isAccepted = false;
    await _messageServices.acceptMoney(messageId).then((value) {
      d.Response response = value;
      if (response.statusCode == 200 || response.statusCode == 201) {
        isAccepted = true;
        print('Money accepted');
      } else {
        print('Money not accepted');
      }
    });
    isLoading.value = false;
    return isAccepted;
  }
}
