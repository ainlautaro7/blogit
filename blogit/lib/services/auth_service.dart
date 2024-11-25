import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthServices {
  final String baseUrl = "http://0.0.0.0:3000";

  Future<Map<String, dynamic>> register(
      {required String username, required String password}) async {
    final url = Uri.parse('$baseUrl/users/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 201) {
        // Registro exitoso
        return json.decode(response.body);
      } else {
        // Error en el registro
        return {
          'error': true,
          'message':
              json.decode(response.body)['message'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> login(
      {required String username, required String password}) async {
    final url = Uri.parse('$baseUrl/users/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Inicio de sesión exitoso
        return json.decode(response.body);
      } else {
        // Error en el inicio de sesión
        return {
          'error': true,
          'message':
              json.decode(response.body)['message'] ?? 'Error desconocido',
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Error al conectar con el servidor',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile(User user) async {
    final url = Uri.parse(
        '$baseUrl/users/update'); // Cambia esta URL según el endpoint de tu API

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()), // Convierte el objeto User en JSON
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Retorna la respuesta del servidor
      } else {
        return {'error': true, 'message': 'Error al actualizar el perfil'};
      }
    } catch (error) {
      return {'error': true, 'message': 'Error al conectar con el servidor'};
    }
  }
}
