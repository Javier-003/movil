// modelo de datos para el clima
class ClimaModel {
  //propiedades del modelo de clima
  final String ciudad;
  final String pais;
  final String temperatura;
  final String condicion;
  //constructor del modelo de clima
  ClimaModel({
    required this.ciudad,
    required this.pais,
    required this.temperatura,
    required this.condicion,
  });

  //método para convertir el json en un objeto climaModel
  factory ClimaModel.fromJson(Map<String, dynamic> json) {
    return ClimaModel(
      ciudad: json['location']['name'],
      pais: json['location']['country'],
      temperatura: json['current']['temp_c'].toString(),
      condicion: json['current']['condition']['text'],
    );
  }
}