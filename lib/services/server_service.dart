import 'dart:io';

import 'package:http/http.dart';

import '/config/constants.dart';
import '/models/server_error.dart';
import '/models/server_response.dart';

class ServerService {
  static Future<ServerResponse> processResponse(
      Future<Response> response) async {
    try {
      final res = await response;

      if (res.statusCode == 500) {
        String errorMessage;

        try {
          /// Obtener el mensaje de error en la respuesta del servidor, de lo
          /// contrario, mostrar un mensaje de error por defecto.
          errorMessage = ServerResponse.fromJson(res.body).message;
        } catch (e) {
          errorMessage = Constants.errorMessage;
        }

        throw ServerError(message: errorMessage);
      }

      if (res.statusCode == 401) {
        throw const ServerError(
          message: Constants.unAuthorized,
          shouldLogout: true,
        );
      }

      /// Respuesta exitosa
      final body = ServerResponse.fromJson(res.body);
      var status = false;

      try {
        // Manejo de error para cuando la variable [body] no es un objeto
        status = body.status;
      } catch (e) {
        throw const ServerError(message: Constants.errorMessage);
      }

      if (!status) {
        throw ServerError(message: body.message);
      }

      return body;
    } on SocketException {
      throw const ServerError(
        message: Constants.noConnection,
        shouldRetry: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}
