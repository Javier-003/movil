import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyecto_equipo2/model/clima_model.dart';
import 'package:proyecto_equipo2/pages/clima_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClimaService {
  //llamada a la api del clima
  String baseUrl = 'http://api.weatherapi.com/v1';
  //obtener la key de .env
  final apiKey = dotenv.env['keyApiClimate'];
  //método para obtener el clima actual de una ciudad
  Future<ClimaModel> climaActual(String ciudad) async {
    //llamada http get a la api
    var url = Uri.parse('$baseUrl/current.json?key=$apiKey&q=$ciudad&lang=es');
    //realizar la solicitud
    var response = await http.get(url);
    //debug de la respuesta
    print('Response status: ${response.body}');
    //convertir la respuesta en un objeto climaModel
    ClimaModel clima = ClimaModel.fromJson(jsonDecode(response.body));
    return clima;
    }
}
  