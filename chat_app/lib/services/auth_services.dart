import 'dart:developer';

import 'package:chat_app/data/injection/dependency_injection.dart';
import 'package:chat_app/data/local/cache_manager.dart';
import 'package:chat_app/data/networks/dio_simple.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthServices {
  DioNetwork dioNetwork = DioNetwork();
  final String _auth = dotenv.env['AUTH']!;
  final String _refreshToken = dotenv.env['REFRESH_TOKEN']!;
  final String _register = dotenv.env['REGISTER']!;
  final String _verifyOtp = dotenv.env['VERIFY_OTP']!;
  final String _sendOtp = dotenv.env['SEND_OTP']!;
  Future<dynamic> sendOtp(String number) async {
    log("In 2");
    Map<String, String> data = {"number": number};
    log(_auth + _sendOtp);
    try {
      Response response = await dioNetwork.postData(_auth + _sendOtp,data: data);

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<dynamic> verifyOtp(String number, String otp) async {
    log("In 2");
    Map<String, String> data = {"number": number, "otp": otp};
    log(_auth + _verifyOtp);
    try {
      Response response = await dioNetwork.postData(_auth + _verifyOtp, data: data);

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
  Future<dynamic> signup(String number,String email,String name, String image)async{
    Map<String,String> data = {
      "name":name,
      "email":email,
      "phone":number,
      "profileImageUrl":image,
      "notificationToken":getIt<CacheManager>().getNotificationSubscriptionId()
    };
    try {
      Response response = await dioNetwork.postData(_auth + _register,data: data);

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
