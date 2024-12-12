import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/services/one_signal_services.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/injection/dependency_injection.dart';
import '../../data/local/cache_manager.dart';

part 'check_login_event.dart';
part 'check_login_state.dart';

class CheckLoginBloc extends Bloc<CheckLoginEvent, CheckLoginState> {
  CheckLoginBloc() : super(CheckLoginInitial()) {
    on<CheckAlreadyLogin>(_checkLogin);
  }

  _checkLogin(CheckAlreadyLogin event, Emitter<CheckLoginState> emit) async{
    emit(CheckLoginLoading());
    await getIt<OneSignalServices>().initPlatformState();

  //s  await getIt<OneSignalServices>().setUserLogin();
    bool login =  getIt<CacheManager>().getLoggedIn()!;

    log(login.toString());
    if (login){
      emit(CheckLoginSuccess());
    }else{
      emit(CheckLoginFailed());
    }

  }
}
