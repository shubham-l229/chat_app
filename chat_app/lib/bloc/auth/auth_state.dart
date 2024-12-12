part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSendOtpSuccessFull extends AuthState {}

class AuthSendOtpFail extends AuthState {}

class AuthSendOtpLoading extends AuthState {}
class AuthSignupSuccessFull extends AuthState {}

class AuthSignupFail extends AuthState {}

class AuthSignupLoading extends AuthState {}

class AuthVerifyOtpSuccess extends AuthState {}

class AuthVerifyOtpFail extends AuthState {}

class AuthVerifyOtpLoaading extends AuthState {}
