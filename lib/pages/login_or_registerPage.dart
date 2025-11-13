
import 'package:flutter/material.dart';
import 'package:proyecto_equipo2/pages/login_page.dart';
import 'package:proyecto_equipo2/pages/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => LoginOrRegisterPageState();
}

class LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initialmente mostrar página de inicio de sesión
  bool showLoginPage = true;


  // alternar entre la página de inicio de sesión y registro
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  // método de construcción para mostrar la página apropiada
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}