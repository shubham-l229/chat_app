import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:meta/meta.dart';

import '../../data/injection/dependency_injection.dart';
import '../../data/models/users_model.dart';
import '../../data/repositories/users_repositories.dart';
import '../../services/one_signal_services.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepositories _usersRepositories = UsersRepositories();
  UsersBloc() : super(UsersInitial()) {
    on<GetUsers>(_getUser);
  }

  _getUser(GetUsers event, Emitter<UsersState> emit) async {
    emit(GetUserLoading());
    await getIt<OneSignalServices>().setNotificationToken();

    UsersModel usersModel = await _usersRepositories.getUsers();
    if (usersModel == null) {
      emit(GetUserFailed());
    }

    getIt<SocketServices>().connect();
    emit(GetUserSuccess(usersModel: usersModel));
  }
}
