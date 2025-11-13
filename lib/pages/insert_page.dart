import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_equipo2/services/firebase_service.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> { 
  //controladores para los campos de texto
  TextEditingController nombreController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController precioController = TextEditingController();

  //frontend de la pagina de insercion de productos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Insert Page'),
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
                  onPressed: () async { await insertproducto(nombreController.text,
                   categoriaController.text, 
                   precioController.text).then((value) {
                    Navigator.pop(context,'/');
                   });
                  },
                  child: const Text("Insertar Producto"))
            ],
          ),
        ));
  }
}
