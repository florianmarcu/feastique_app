
import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {

  StreamSubscription? authStreamSubscription;

  AppCubit() : super(const LoadingAppState()){
    authStreamSubscription = Authentication.user.listen((user) {
      if(user != null){
        emit(AuthenticatedAppState(user: user));
      }
      else{
        emit(UnauthenticatedAppState());
      }
    });
  }

  @override
  Future<void> close() {
    authStreamSubscription?.cancel();
    return super.close();
  }
}