part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}
class AuthSendOtp extends AuthEvent{
  final String phoneNumber;

  AuthSendOtp({required this.phoneNumber});


}
class AuthVerifyOtp extends AuthEvent{
  final String otp;

  AuthVerifyOtp({required this.otp});
  
}

class AuthSignUp extends AuthEvent{
  final String email;
  final String name;
  final String image;

  AuthSignUp({required this.email, required this.name, required this.image});

}