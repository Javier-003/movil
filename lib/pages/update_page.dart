import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_equipo2/services/firebase_service.dart';
class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> { 

  TextEditingController nombreController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //obtener argumentos pasados a esta página
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    nombreController.text = args['nombre'];
    categoriaController.text = args['categoria']; 
    precioController.text = args['precio'].toString();
    
  //frontend de la pagina de actualizacion de productos
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Page'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Introduce nombre del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: categoriaController,
                decoration: InputDecoration(
                  labelText: 'Categoría del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(
                  labelText: 'Precio del producto',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number, // teclado numérico
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async { await updateproducto(args["id"],nombreController.text,
                   categoriaController.text, 
                   precioController.text).then((value) {
                    Navigator.pop(context,'/');
                   });
                  },
                  child: const Text("Actualizar Producto"))
            ],
          ),
        ));
  }
}