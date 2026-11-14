import 'package:dio/dio.dart';
import 'package:rehla/core/storage/secure_storage_service.dart';
import 'package:rehla/features/auth/models/signup_user_model.dart';
import 'package:rehla/features/user/home/models/category_model.dart';
import 'package:rehla/features/user/home/models/trip_models.dart';

class ApiDataSourse {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://rehla-app-backend-api.vercel.app/api/v1/",
      // connectTimeout: const Duration(seconds: 15),
      // receiveTimeout: const Duration(seconds: 15),
    ),
  );

  ApiDataSourse() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.instance.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Auth functions:
  Future<Map<String, dynamic>> register(SignupUserModel signupUserModel) async {
    Response response;
    try {
      response = await _dio.post(
        "/auth/register",
        data: signupUserModel.toJson(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        response = await _dio.post(
          "auth/register",
          data: signupUserModel.toJson(),
        );
      } else {
        rethrow;
      }
    }

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final token =
          rawData['token'] ??
          rawData['accessToken'] ??
          (rawData['data'] is Map ? rawData['data']['token'] : null);
      if (token is String && token.isNotEmpty) {
        await SecureStorageService.instance.saveToken(token);
      }
      return rawData;
    }
    return {};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    Response response;
    final body = {"email": email, "password": password};

    try {
      response = await _dio.post("auth/login", data: body);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        response = await _dio.post("auth/login", data: body);
      } else {
        rethrow;
      }
    }

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final token =
          rawData['token'] ??
          rawData['accessToken'] ??
          (rawData['data'] is Map ? rawData['data']['token'] : null);
      if (token is String && token.isNotEmpty) {
        await SecureStorageService.instance.saveToken(token);
      }

      final user =
          rawData['user'] ??
          (rawData['data'] is Map ? rawData['data']['user'] : null);
      if (user is Map) {
        await SecureStorageService.instance.saveUserData(
          name: user['name']?.toString(),
          email: user['email']?.toString() ?? email,
          phone: user['phone']?.toString(),
        );
      }

      return rawData;
    }
    return {};
  }

  // Categories
  Future<List<CategoryModel>> getAllCategories() async {
    List<CategoryModel> categories = [];
    var res = await _dio.get("categories");

    final rawData = res.data;
    final List<dynamic>? list = rawData is Map ? rawData["categories"] : null;
    if (list != null) {
      for (var category in list) {
        if (category is Map<String, dynamic>) {
          categories.add(CategoryModel.fromJson(category));
        }
      }
    }
    return categories;
  }

  // Trips
  Future<List<TripModel>> getAllTrips({
    String? categoryId,
    String? search,
  }) async {
    List<TripModel> trips = [];
    final Map<String, dynamic> queryParameters = {};
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParameters['category'] = categoryId;
    }
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    var response = await _dio.get(
      "trips",
      queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
    );
    final rawData = response.data;
    final List<dynamic>? list = rawData is Map
        ? (rawData['data'] ?? rawData['trips'])
        : null;
    if (list != null) {
      for (var item in list) {
        if (item is Map<String, dynamic>) {
          trips.add(TripModel.fromJson(item));
        }
      }
    }
    return trips;
  }

  // Trip Details: /trips/:id
  Future<TripModel> getTripById(String id) async {
    var response = await _dio.get("trips/$id");
    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final tripMap = rawData['data'] ?? rawData['trip'] ?? rawData;
      if (tripMap is Map<String, dynamic>) {
        return TripModel.fromJson(tripMap);
      }
    }
    throw Exception("فشل في تحميل تفاصيل الرحلة");
  }
}
