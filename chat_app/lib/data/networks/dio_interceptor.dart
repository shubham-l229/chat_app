import 'dart:developer';
import 'dart:io';

import 'package:chat_app/data/local/cache_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../errors/error_handing.dart';
import '../injection/dependency_injection.dart';

class DioInterceptor extends Interceptor {
  var cacheManager = getIt<CacheManager>();
  final _errorHandling = ErrorHandling();

  final Dio _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL']! + dotenv.env['VERSION']!,
      connectTimeout: const Duration(seconds: 200),
      receiveTimeout: Duration(seconds: 200),
      responseType: ResponseType.json,
      contentType: "application/json"));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = cacheManager.getAccessToken();
    options.headers.addAll({
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }


  Future<dynamic> postData(String path, Map<String, dynamic> data) async {
    _dio.interceptors.add(LogInterceptor(responseBody: true));

    log("IN 3");
    try {
      Response response = await _dio.post(path, data: data);
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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Refresh the user's authentication token.
      await refreshToken();
      // Retry the request.r
      try {
        err.requestOptions.headers["Authorization"] =
        'Bearer ${cacheManager.getAccessToken()}';
         Response response =  await _dio.fetch(err.requestOptions);
         if(response.statusCode==200||response.statusCode==201){
           return handler.resolve(response);
         }else{
          ///
         }

      } on DioException catch (e) {
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
    super.onError(err, handler);
  }

  Future<Response<dynamic>> refreshToken() async {
    _dio.interceptors.add(DioInterceptor());

    var response = await _dio.post("auth/refresh-token",
        data: {"refreshToken": cacheManager.getRefreshToken()},
        options: Options(headers: {
          "Content-Type": "application/json",
        }));
    // on success response, deserialize the response
    if (response.statusCode == 200) {
      log(response.data.toString());
      // LoginRequestResponse requestResponse =
      //    LoginRequestResponse.fromJson(response.data);
      // UPDATE the STORAGE with new access and refresh-tokens
      await cacheManager.setToken(
          response.data["accessToken"], response.data["refreshToken"]);
    }
    return response;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Create a new `RequestOptions` object with the same method, path, data, and query parameters as the original request.
    log("Krish retry");
    String token = cacheManager.getAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    // Retry the request with the new `RequestOptions` object.
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
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
      data: {
        "success": false,
        "message": "Please check your network connection and try again."
      },
      statusCode: 401,
      requestOptions:
          RequestOptions(headers: {'Content-Type': 'application/json'}),
    );
  }
}
