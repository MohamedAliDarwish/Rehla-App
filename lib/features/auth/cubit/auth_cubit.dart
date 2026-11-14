import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehla/core/data_sourse/api_data_sourse.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';
import 'package:rehla/features/auth/cubit/auth_states.dart';
import 'package:rehla/features/auth/models/signup_user_model.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitState());

  final ApiDataSourse _apiDataSourse = ApiDataSourse();

  Future<void> signup(SignupUserModel usermodel) async {
    emit(AuthLoadingState());
    try {
      final res = await _apiDataSourse.register(usermodel);
      emit(AuthSignupSucessState(data: res));
    } catch (e) {
      emit(AuthErrorState(errorMessage: _getErrorMessage(e)));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoadingState());
    try {
      final res = await _apiDataSourse.login(email, password);
      emit(AuthLoginSuccessState(data: res));
    } catch (e) {
      emit(AuthErrorState(errorMessage: _getErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    await SecureStorageService.instance.logout();
    emit(AuthLoggedOutState());
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      if (e.response?.data is Map) {
        final msg = e.response?.data['message'] ?? e.response?.data['error'];
        if (msg != null) return msg.toString();
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return "انتهت مهلة الاتصال بالخادم، يرجى المحاولة لاحقاً";
      }
      if (e.type == DioExceptionType.connectionError) {
        return "تعذر الاتصال بالخادم، تأكد من اتصالك بالإنترنت";
      }
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}
