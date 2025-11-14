import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_equipo2/model/clima_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClimaService {
  // Llamada a la API del clima (DEBE ser https)
  String baseUrl = 'https://api.weatherapi.com/v1';
  // Obtener la key de .env
  final apiKey = dotenv.env['keyApiClimate'];
  // Método para obtener el clima actual de una ciudad
  Future<ClimaModel> climaActual(String ciudad) async {
    // Verificación de que el servidor usa HTTPS  
    if (!baseUrl.startsWith("https://")) {
      throw Exception(
        "Conexión insegura: el servidor no usa HTTPS (comunicación no cifrada)."
      );
    }
    final url = Uri.parse(
        '$baseUrl/current.json?key=$apiKey&q=$ciudad&lang=es');

    // Valida que también el URL final sea https
    if (url.scheme != "https") {
      throw Exception(
        "La URL no usa HTTPS. La conexión no es segura."
      );
    }
    try {
      // Realizar la solicitud GET a la API del clima
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () =>
            throw Exception("La solicitud tardó demasiado (timeout)"),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      switch (response.statusCode) {
        case 200:
          //Validacion por si el json viene vacio o roto
          final data = jsonDecode(response.body);
          return ClimaModel.fromJson(data);

        case 400:
          throw Exception("400 - Solicitud incorrecta (Bad Request)");
        case 401:
          throw Exception("401 - API Key inválida o no autorizada");
        case 403:
          throw Exception("403 - Acceso denegado");
        case 404:
          throw Exception("404 - Ciudad no encontrada");
        case 429:
          throw Exception("429 - Demasiadas solicitudes (Rate Limit)");
        case 500:
          throw Exception("500 - Error interno del servidor");

        default:
          throw Exception(
            "Error desconocido: ${response.statusCode} - ${response.reasonPhrase}",
          );
      }
    } catch (e) {
      throw Exception("Error en la conexión o en la solicitud: $e");
    }
  }
}
