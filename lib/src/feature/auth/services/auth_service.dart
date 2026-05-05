import 'dart:convert';

import 'package:amazon/src/config/env_config.dart';
import 'package:amazon/src/model/api_response.dart';
import "package:http/http.dart" as http;

class AuthService {
  final defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final envConf = EnvConfig();
    try {
      final res = await http.post(
        envConf.getApiBaseUrl(path: "/auth/register"),
        headers: defaultHeaders,
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Something went wrong",
        data: null,
      );
    }
  }

  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final envConf = EnvConfig();
    try {
      final res = await http.post(
        envConf.getApiBaseUrl(path: "/auth/login"),
        headers: defaultHeaders,
        body: jsonEncode({"email": email, "password": password}),
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Something went wrong",
        data: null,
      );
    }
  }

  Future<ApiResponse> logout({required String token}) async {
    final envConf = EnvConfig();
    try {
      final res = await http.post(
        envConf.getApiBaseUrl(path: "/auth/logout"),
        headers: {...defaultHeaders, "Authorization": "Bearer $token"},
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Something went wrong",
        data: null,
      );
    }
  }

  Future<ApiResponse> getCurrentUser({required String token}) async {
    final envConf = EnvConfig();
    try {
      final res = await http.get(
        envConf.getApiBaseUrl(path: "/auth/login"),
        headers: {...defaultHeaders, "Authorization": "Bearer $token"},
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Something went wrong",
        data: null,
      );
    }
  }
}
