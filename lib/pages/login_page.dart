import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:proyecto_equipo2/components/my_buttom.dart';
import 'package:proyecto_equipo2/components/my_textfield.dart';
import 'package:proyecto_equipo2/components/square_title.dart';
import 'package:proyecto_equipo2/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controladores para los campos de texto
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //método para iniciar sesión del usuario
  void signUserIn() async {
    // Datos que queremos mostrar (solo debug)
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Enmascarar contraseña para evitar exposición completa en logs
    String maskPassword(String p) {
      if (p.isEmpty) return '(empty)';
      final visible = 2; // cuántos caracteres mostrar al final
      final shown =
          p.length <= visible ? p : '***' + p.substring(p.length - visible);
      return shown;
    }

    // Imprimir lo que se enviará (modo debug)
    print('DEBUG -> Intentando iniciar sesión con:');
    print('  email: $email');
    print(
        '  password (masked): ${maskPassword(password)}'); // nunca prints la contraseña completa en logs públicos

    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Llamada a Firebase (envía por HTTPS internamente)
      UserCredential cred =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // pop the loading circle
      Navigator.pop(context);

      // Información devuelta por Firebase
      final user = cred.user;
      print('DEBUG -> signInWithEmailAndPassword success');
      print('  user.uid: ${user?.uid}');
      print('  user.email: ${user?.email}');

      // Obtener token de identificación (ID token) — sensible
      final idToken = await user?.getIdToken();
      print('  idToken (sensitive): $idToken');

      // Redirigir al home
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // Imprimir error detallado en consola (solo debug)
      print(
          'DEBUG -> FirebaseAuthException: code=${e.code}, message=${e.message}');
      genericErrorMessage(e.code);
    } catch (e) {
      Navigator.pop(context);
      print('DEBUG -> Exception inesperada: $e');
      genericErrorMessage('Ocurrió un error inesperado');
    }
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  //frontend de la pagina de login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                //logo
                const Icon(
                  Icons.lock_person,
                  size: 100,
                ),
                const SizedBox(height: 10),
                //welcome back you been missed

                Text(
                  'Bienvenido Usuario',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 25),

                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Username or email',
                  obscureText: false,
                ),

                const SizedBox(height: 15),
                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                //sign in button
                MyButton(
                  onTap: signUserIn,
                  text: 'Sign In',
                ),
                const SizedBox(height: 20),

                const SizedBox(
                  height: 10,
                ),

                // continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                //google + apple button

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google buttom
                    SquareTile(
                      //inciar sesion con google
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/icons/google.svg',
                      height: 70,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),

                // not a memeber ? register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
