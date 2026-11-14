sealed class AuthStates {}

class AuthInitState extends AuthStates {}

class AuthLoadingState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String errorMessage;

  AuthErrorState({required this.errorMessage});
}

class AuthSignupSucessState extends AuthStates {
  final Map<String, dynamic> data;

  AuthSignupSucessState({this.data = const {}});
}

class AuthLoginSuccessState extends AuthStates {
  final Map<String, dynamic> data;

  AuthLoginSuccessState({this.data = const {}});
}

class AuthLoggedOutState extends AuthStates {}
