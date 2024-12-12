
import 'package:flutter/material.dart';

class AppNotification extends Notification{
  final Map<String,dynamic> json;

  AppNotification({required this.json}){
    print("object");
  }

}