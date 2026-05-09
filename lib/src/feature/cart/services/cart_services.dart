import 'dart:convert';

import 'package:amazon/src/config/env_config.dart';
import 'package:amazon/src/model/api_response.dart';
import "package:http/http.dart" as http;

class CartServices {
  final EnvConfig envConfig = EnvConfig();

  final defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<ApiResponse> getAllCarts({required String token}) async {
    try {
      final res = await http.get(
        envConfig.getApiBaseUrl(path: "/cart"),
        headers: {...defaultHeaders, "Authorization": "Bearer $token"},
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Failed to get carts data",
        data: null,
      );
    }
  }

  Future<ApiResponse> addToCart({
    required String token,
    required String productId,
    required int qty,
  }) async {
    try {
      final res = await http.post(
        envConfig.getApiBaseUrl(path: "/cart/add-to-cart"),
        headers: {...defaultHeaders, "Authorization": "Bearer $token"},
        body: jsonEncode({"productId": productId, "qty": qty}),
      );
      return ApiResponse.fromJson(res.body);
    } catch (e) {
      return ApiResponse(
        success: false,
        message: "Gagal menambahkan produk ke keranjang",
        data: null,
      );
    }
  }
}
