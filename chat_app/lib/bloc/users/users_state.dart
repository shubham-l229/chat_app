part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}
class GetUserSuccess extends UsersState{
  final UsersModel usersModel;

  GetUserSuccess({required this.usersModel});
}
class GetUserFailed extends UsersState{}
class GetUserLoading extends UsersState{}