import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';
import 'package:rehla/features/user/profile/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitState());

  Future<void> loadProfile() async {
    emit(ProfileLoadingState());
    final data = await SecureStorageService.instance.getUserData();
    final name = data['name'];
    emit(ProfileLoadedState(
      name: (name == null || name.isEmpty) ? 'مستخدم رحلة' : name,
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
    ));
  }

  Future<void> logout() async {
    await SecureStorageService.instance.logout();
    emit(ProfileLoggedOutState());
  }
}