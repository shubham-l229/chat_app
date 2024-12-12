import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../errors/error_handing.dart';
import '../injection/dependency_injection.dart';
import '../local/cache_manager.dart';
import 'dio_interceptor.dart';

class DioNetwork  {
  var cacheManager = getIt<CacheManager>();
  final _errorHandling = ErrorHandling();
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _version = dotenv.env['VERSION']!;
  final Dio _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']!+dotenv.env['VERSION']!,


      responseType: ResponseType.json,
      contentType: "application/json"));

  Future<dynamic> getData(
      String path,
      ) async {
    //_dio.interceptors.add(LogInterceptor(responseBody: false,requestBody: false));
     _dio.interceptors.add(DioInterceptor());
    try {
      Response response = await _dio.get(path);

      return response;
    } catch (err) {
      log(err.toString());
      if (err is SocketException) {
        return await _errorHandling.manageErrors(_timeoutResponse());
      } else {
        return await _errorHandling.manageErrors(_errorResponse());
      }
    }
  }


  Future<dynamic> postData(String path, {Map<String, dynamic>? data}) async {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
if(getIt<CacheManager>().getLoggedIn()!){
  _dio.interceptors.add(DioInterceptor());
}
    log("IN 3");
    try {

      Response response = await _dio.post(path, data: data);
      log(response.statusCode.toString());
      return response;
    }  catch (err) {
      log(err.toString());
      if (err is SocketException) {
        return await _errorHandling.manageErrors(_timeoutResponse());
      } else {
        return await _errorHandling.manageErrors(_errorResponse());
      }
    }
  }

  Response _errorResponse() {
    return Response(
      data: {"success": false, "message": "Some Error Occurred At Our End"},
      statusCode: 401,
      requestOptions:
          RequestOptions(headers: {'Content-Type': 'application/json'}),
    );
  }
  Response _timeoutResponse() {
    return Response(
      data:{
        "success": false,
        "message": "Please check your network connection and try again."
      },
      statusCode:    401,
      requestOptions:
      RequestOptions(headers: {'Content-Type': 'application/json'}),
    );
  }

}
