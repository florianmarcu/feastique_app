part of 'app_cubit.dart';

abstract class AppState extends Equatable{
  const AppState();
}

class LoadingAppState extends AppState{
  const LoadingAppState();
  
  @override
  List<Object?> get props => [];
}

/// The AppState when the user is [authenticated]
class AuthenticatedAppState extends AppState{
  const AuthenticatedAppState({
    required this.user
  });

  final User user;
  
  @override
  List<Object?> get props => [user];
}

/// The AppState when the user is [unauthenticated]
class UnauthenticatedAppState extends AppState{
  const UnauthenticatedAppState();
  
  @override
  List<Object?> get props => [];
}