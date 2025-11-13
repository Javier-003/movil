import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_equipo2/pages/clima_page.dart';
import 'package:proyecto_equipo2/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
 //Estado de la página principal con navegación inferior
class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int _paginaActual = 0;

  // Función para cerrar sesión del usuario
  Future<void> signUserOut() async {
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
  }
  // Construcción de la interfaz de usuario osea el frontend
  @override
  Widget build(BuildContext context) {
    // Lista de páginas que cambiarán con el BottomNavigationBar
    final List<Widget> paginas = [
      _buildProductosView(),
      const Clima(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('APP'),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: paginas[_paginaActual],
      floatingActionButton: _paginaActual == 0
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/AgregarProducto');
                setState(() {});
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: (index) => setState(() => _paginaActual = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Clima',
          ),
        ],
      ),
    );
  }

  /// Vista principal con la lista de productos
  Widget _buildProductosView() {
    return FutureBuilder(
      future: getproductos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data!;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return Dismissible(
                key: Key(producto['id']),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: const Color.fromARGB(120, 244, 67, 54),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.black),
                ),
                confirmDismiss: (direction) async {
                  bool result = false;
                  result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar eliminación'),
                      content: const Text(
                        '¿Estás seguro de que deseas eliminar este producto?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteproducto(producto['id']);
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  return result;
                },
                child: ListTile(
                  title: Text(producto['Nombre']),
                  subtitle: Text(
                    'Categoría: ${producto['Categoria']} - Precio: \$${producto['Precio']}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context,
                        '/ActualizarProducto',
                        arguments: {
                          'id': producto['id'],
                          'nombre': producto['Nombre'],
                          'categoria': producto['Categoria'],
                          'precio': producto['Precio'].toString(),
                        },
                      );
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
