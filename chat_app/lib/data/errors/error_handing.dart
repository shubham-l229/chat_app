import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ErrorHandling {
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  dynamic manageErrors(Response response) {
    log("Status Code ${response.statusCode}");
    log("Body ${response.data}");

    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      print("object");
      return response;
    } else {

      Map<String, dynamic> result = jsonDecode(response.data);
      // AppUtils().showAlertDialog("Error", result["message"]);

      return null;
    }
  }
}
