import 'package:amazon/src/config/env_config.dart';
import 'package:amazon/src/model/api_response.dart';
import "package:http/http.dart" as http;

class ProductServices {
  Future<ApiResponse> getAllProducts() async {
    final envConf = EnvConfig();
    try {
      final res = await http.get(envConf.getApiBaseUrl(path: "/products"));
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Failed to get products",
        data: null,
      );
    }
  }
}
