import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../data/networks/dio_simple.dart';

class UsersServices{
  DioNetwork dioInterceptor = DioNetwork();
  final String _user = dotenv.env['USERS']!;
  final String _getAllUsers = dotenv.env['GET_ALL_USERS']!;
  Future<dynamic> getUsers()async{

    try {
      Response response = await dioInterceptor.getData(_user + _getAllUsers);

      return response;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}