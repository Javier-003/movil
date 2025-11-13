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
  //llamado a la api para obtner el clima segun la ciudad obtenida por geolocalizacion
  llamarApi() async {
    var Ciudad = GeolocatorService().obtenerciudad();
    _clima = await ClimaService().climaActual(await Ciudad);
    setState(() {});
  }

  //init state para llamar a la api al iniciar la pagina
  @override
  void initState() {
    super.initState();
    llamarApi();
  }

  //frontend de la pagina del clima
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text('${_clima?.ciudad ?? "Cargando Ciudad"}',
              style: const TextStyle(fontSize: 30),),
            Text('${_clima?.pais ?? "Cargando País"}',
              style: const TextStyle(fontSize: 30),),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              child: Icon(Icons.sunny, size: 100, color: Colors.yellow),
            ),
            const Text(
              "Temperatura",
              style: const TextStyle(fontSize: 50),
            ),
            Text(
              "${_clima?.temperatura ?? "Cargando Temperatura"} C",
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
