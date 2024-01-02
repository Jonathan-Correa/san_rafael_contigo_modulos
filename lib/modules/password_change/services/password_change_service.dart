import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:csr_shared_modules/models/server_response.dart';
import 'package:csr_shared_modules/services/server_service.dart';

class PasswordChangeService {
  final String userType;
  final String apiToken;
  final String apiUrl;

  PasswordChangeService({
    required this.userType,
    required this.apiToken,
    required this.apiUrl,
  });

  Future<ServerResponse> requestPasswordChange(
    String documentNumber,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': apiToken,
    };

    final uri = Uri.parse('$apiUrl/requestPasswordChange');
    final response = http.post(
      uri,
      headers: headers,
      body: jsonEncode(
        {'user_type': userType, 'document_number': documentNumber},
      ),
    );

    return await ServerService.processResponse(response);
  }

  Future<ServerResponse> validateCode(
    String code,
    String documentNumber,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': apiToken,
    };

    final uri = Uri.parse('$apiUrl/validatePasswordChangeRequest');
    final response = http.post(
      uri,
      headers: headers,
      body: jsonEncode(
        {
          'user_type': userType,
          'code': code,
          'document_number': documentNumber,
        },
      ),
    );

    return await ServerService.processResponse(response);
  }

  Future<ServerResponse> changePassword(
    String password,
    String code,
    String documentNumber,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': apiToken,
    };

    final uri = Uri.parse('$apiUrl/resetPassword');
    final response = http.post(
      uri,
      headers: headers,
      body: jsonEncode(
        {
          'code': code,
          'password': password,
          'user_type': userType,
          'document_number': documentNumber,
        },
      ),
    );

    return await ServerService.processResponse(response);
  }
}
