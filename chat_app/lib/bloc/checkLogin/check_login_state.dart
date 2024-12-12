part of 'check_login_bloc.dart';

@immutable
abstract class CheckLoginState {}

class CheckLoginInitial extends CheckLoginState {}
class CheckLoginSuccess extends CheckLoginState{}
class CheckLoginFailed extends CheckLoginState{}
class CheckLoginLoading extends CheckLoginState{}