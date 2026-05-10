import 'package:amazon/src/config/env_config.dart';
import 'package:amazon/src/model/api_response.dart';
import "package:http/http.dart" as http;

class OrderServices {
  final EnvConfig envConfig = EnvConfig();
  final defaultHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };
  Future<ApiResponse> getAllOrders({required String token}) async {
    try {
      final res = await http.get(
        envConfig.getApiBaseUrl(path: "/order"),
        headers: {...defaultHeaders, "Authorization": "Bearer $token"},
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Gagal mendapatkan data order",
        data: null,
      );
    }
  }
}
