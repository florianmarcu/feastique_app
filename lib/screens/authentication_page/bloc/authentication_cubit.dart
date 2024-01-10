import 'package:authentication/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState());

  void logIn(BuildContext context, String signInMethod) async{
    _loading();

    var result;
    switch(signInMethod){
      case "email_and_password":
        result = await Authentication.signInWithEmailAndPassword(state.email!, state.password!);
      break;
      case "anonimously":
        result = await Authentication.signInAnonimously();
      break;
      case "google":
        result = await Authentication.signInWithGoogle();
      break;
      case "facebook":
        result = await Authentication.signInWithFacebook();
      break;
    }

    if(result.runtimeType == FirebaseAuthException)
      _handleAuthError(context, result);

    _loading();
  }

  void setEmail(String? email){
    emit(state.copyWith(email: email));
  }

  void setPassword(String? password){
    emit(state.copyWith(password: password));
  }

  void setPasswordVisibility(){
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  /// Upon any error returned by the sign-in methods, shows a SnackBar accordignly
  void _handleAuthError(BuildContext context, FirebaseAuthException error){
    var errorCodeToText = {
      "invalid-email": "Emailul introdus este invalid", 
      "user-disabled": "Contul introdus este dezactivat", 
      "user-not-found": "Nu există utilizator pentru emailul introdus", 
      "wrong-password": "Combinația de email și parolă este greșită"
    };
    print(error.code);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorCodeToText[error.code]!),
      )
    ).closed
    .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  void _loading(){
    emit(state.copyWith(isLoading: !state.isLoading));
  }
}