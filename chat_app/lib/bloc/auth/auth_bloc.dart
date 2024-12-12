import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../data/injection/dependency_injection.dart';
import '../../data/local/cache_manager.dart';
import '../../services/one_signal_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthSendOtp>(_sendOtp);
    on<AuthVerifyOtp>(_verifyOtp);
    on<AuthSignUp>(_signup);
  }
  var _cacheManager = getIt<CacheManager>();
  String _phoneNumber = ""; // Private variable for phoneNumber
  bool _registerdUser = false;

  // Getter for phoneNumber
  String get phoneNumber => _phoneNumber;

  // Setter for phoneNumber
  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  bool get registerdUser => _registerdUser;

  _sendOtp(AuthSendOtp event, Emitter<AuthState> emit) async {
    log("In 1");
    emit(AuthSendOtpLoading());
    phoneNumber = event.phoneNumber;
    Response data = await AuthServices().sendOtp(event.phoneNumber);
    if (data.statusCode == 200) {
      var result = data.data;
      log(result.toString());
      if (result["isOtpSendt"] == true) {
        _registerdUser = result["registeredUser"];
      }
      emit(AuthSendOtpSuccessFull());
    }

    emit(AuthSendOtpFail());
  }

  _verifyOtp(AuthVerifyOtp event, Emitter<AuthState> emit) async {
    log("In 1");
    emit(AuthVerifyOtpLoaading());
    Response data = await AuthServices().verifyOtp(_phoneNumber, event.otp);
    if ((data.statusCode == 201 || data.statusCode == 200) &&
        (data.data["isVerified"] == true || data.data["success"] == true)) {
      var result = data.data;
      if (_registerdUser) {
        String accessToken = result["user"]["accessToken"];
        String refreshToken = result["user"]["refreshToken"];
        _cacheManager.setToken(accessToken, refreshToken);
        _cacheManager.setUserId(result["user"]["userId"]);
        _cacheManager.setLoggedIn();
      }
      emit(AuthVerifyOtpSuccess());
    }

    emit(AuthVerifyOtpFail());
  }

   _signup(AuthSignUp event, Emitter<AuthState> emit) async{
     log("In 1");
     emit(AuthSignupLoading());
     getIt<OneSignalServices>().setNotificationToken();
     Response data = await AuthServices().signup(_phoneNumber, event.email,event.name,event.image);
     if ((data.statusCode == 201 || data.statusCode == 200) &&
         (data.data["isVerified"] == true || data.data["success"] == true)) {
       var result = data.data;
print(result);
       String accessToken = result["user"]["accessToken"];
       String refreshToken = result["user"]["refreshToken"];
        await  _cacheManager.setToken(accessToken, refreshToken);
       await _cacheManager.setUserId(result["user"]["userId"]);

       await _cacheManager.setLoggedIn();

       emit(AuthSignupSuccessFull());
     }

     emit(AuthSignupFail());
  }
}
