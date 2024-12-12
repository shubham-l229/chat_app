part of 'check_login_bloc.dart';

@immutable
abstract class CheckLoginEvent {}
class CheckAlreadyLogin extends CheckLoginEvent{}