import 'dart:developer';

import 'package:chat_app/services/users_services.dart';
import 'package:dio/dio.dart';

import '../models/users_model.dart';

class UsersRepositories{
  final UsersServices _usersServices = UsersServices();
  Future<dynamic> getUsers()async{
    Response response = await _usersServices.getUsers();
    if(response.statusCode==200||response.statusCode==201){
      UsersModel usersModel = UsersModel.fromJson(response.data);
      return usersModel;
    }
    return null;
  }
}