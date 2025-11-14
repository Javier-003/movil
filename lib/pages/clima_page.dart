import 'package:flutter/material.dart';
import 'package:proyecto_equipo2/model/clima_model.dart';
import 'package:proyecto_equipo2/services/clima_service.dart';
import 'package:proyecto_equipo2/services/geolocator_service.dart';

class Clima extends StatefulWidget {
  const Clima({super.key});

  @override
  State<Clima> createState() => _ClimaState();
}

class _ClimaState extends State<Clima> {
  ClimaModel? _clima;
  String? _error;       // <<–– mensaje de error
  bool _cargando = true; // <<–– indicador de loading

  // Llamada a la API 
  Future<void> llamarApi() async {
    try {
      final ciudad = await GeolocatorService().obtenerciudad();

      final clima = await ClimaService().climaActual(ciudad);

      setState(() {
        _clima = clima;
        _error = null;
        _cargando = false;
      });

    } catch (e) {
      setState(() {
        _error = e.toString();  // Guardar error
        _cargando = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    llamarApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _cargando
            ? const CircularProgressIndicator()                                  // LOADING
            : _error != null
    ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.red.shade300, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 60, color: Colors.red.shade400),
              const SizedBox(height: 15),
              Text(
                "Hubo un error al obtener el clima",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _cargando = true;
                    _error = null;
                  });
                  llamarApi();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Reintentar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              )
            ],
          ),
        ),
      )
    // ERROR
                : Column(                                                         // DATOS OK
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _clima!.ciudad,
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        _clima!.pais,
                        style: const TextStyle(fontSize: 30),
                      ),
                      const SizedBox(height: 20),
                      const Icon(Icons.sunny, size: 100, color: Colors.yellow),
                      const SizedBox(height: 20),
                      const Text(
                        "Temperatura",
                        style: TextStyle(fontSize: 40),
                      ),
                      Text(
                        "${_clima!.temperatura} °C",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
      ),
    );
  }
}
