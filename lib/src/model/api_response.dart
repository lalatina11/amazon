// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApiResponse {
  bool success;
  String message;
  dynamic data;
  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  ApiResponse copyWith({bool? success, String? message, dynamic data}) {
    return ApiResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      success: map['success'] as bool,
      message: map['message'] as String,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(String source) =>
      ApiResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ApiResponse(success: $success, message: $message, data: $data)';

  @override
  bool operator ==(covariant ApiResponse other) {
    if (identical(this, other)) return true;

    return other.success == success &&
        other.message == message &&
        other.data == data;
  }

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;
}
