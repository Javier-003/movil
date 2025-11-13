import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proyecto_equipo2/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_equipo2/pages/clima_page.dart';
import 'package:proyecto_equipo2/pages/insert_page.dart';
import 'package:proyecto_equipo2/pages/update_page.dart';
import 'firebase_options.dart';
// Punto de entrada principal de la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cargar variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");
  // Inicializar Firebase con las opciones predeterminadas de la plataforma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Construcción del widget MaterialApp con rutas definidas
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute:'/',
      routes: {
        // Ruta inicial que apunta a la página de autenticación
        '/': (context) => const AuthPage(),
        '/AgregarProducto': (context) => const InsertPage(),
        '/ActualizarProducto':(context) => const UpdatePage(),
        '/ClimaPage':(context) => const Clima(),
      },
    );

  }
}