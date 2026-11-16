sealed class ProfileStates {}

class ProfileInitState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileLoadedState extends ProfileStates {
  final String name;
  final String email;
  final String phone;

  ProfileLoadedState({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class ProfileLoggedOutState extends ProfileStates {}
