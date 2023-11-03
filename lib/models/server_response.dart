import 'dart:convert';

class ServerResponse {
  dynamic data;
  dynamic rawBody;
  String message;
  String? title;
  bool status;
  bool shouldLogout;
  bool shouldRetry;

  ServerResponse({
    required this.data,
    required this.rawBody,
    required this.message,
    required this.status,
    this.title,
    this.shouldLogout = false,
    this.shouldRetry = false,
  });

  factory ServerResponse.error(String message) {
    return ServerResponse(
      data: null,
      status: false,
      rawBody: null,
      title: '!Error',
      message: message,
    );
  }

  ServerResponse copyWith({
    dynamic data,
    String? message,
    bool? status,
    dynamic rawBody,
    String? title,
  }) {
    return ServerResponse(
      data: data ?? this.data,
      title: title ?? this.title,
      status: status ?? this.status,
      rawBody: rawBody ?? this.rawBody,
      message: message ?? this.message,
    );
  }

  factory ServerResponse.fromJson(String str) {
    return ServerResponse.fromMap(json.decode(str));
  }

  factory ServerResponse.fromMap(Map<String, dynamic> map) {
    return ServerResponse(
      rawBody: map,
      data: map['data'],
      title: map['title'],
      message: map['message'] ?? '',
      status: map['status'] ?? false,
    );
  }
}
