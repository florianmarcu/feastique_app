// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_cubit.dart';
// State of the AuthenticationScreen
class AuthenticationState extends Equatable {
  final String? email;
  final String? password;
  final bool passwordVisible;
  final bool isLoading;

  AuthenticationState({
    this.email,
    this.password,
    this.passwordVisible = false,
    this.isLoading = false,
  });
  
  @override
  List<Object?> get props => [email, password, passwordVisible, isLoading];

  AuthenticationState copyWith({
    String? email,
    String? password,
    bool? passwordVisible,
    bool? isLoading,
  }) {
    return AuthenticationState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
