class RegisterResponse {
  final String message;
  final RegisterData? data;

  RegisterResponse({required this.message, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RegisterData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RegisterData {
  final String message;
  final int userId;

  RegisterData({required this.message, required this.userId});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      message: json['message'] as String? ?? '',
      userId: json['userId'] as int? ?? 0,
    );
  }
}
