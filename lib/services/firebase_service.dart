import 'package:cloud_firestore/cloud_firestore.dart';

// instancia de Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

// CRUD de productos en Firestore
Future<List<Map<String, dynamic>>> getProductos() async {
  try {
    List<Map<String, dynamic>> productos = [];

    QuerySnapshot query = await db.collection('productos').get();

    for (var doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      productos.add(data);
    }

    return productos;
  } catch (e) {
    throw Exception("Error al obtener productos: $e");
  }
}

Future<void> insertproducto(
    String nombre, String categoria, String precio) async {
  
  // Sanitización
  nombre = nombre.trim();
  categoria = categoria.trim();
  precio = precio.trim();

  // Validaciones básicas
  if (nombre.isEmpty || categoria.isEmpty || precio.isEmpty) {
    throw Exception("Los campos no pueden estar vacíos.");
  }

  // Validación numérica
  if (double.tryParse(precio) == null) {
    throw Exception("El precio debe ser numérico.");
  }

  // Guardar en Firestore ya sanitizado
  await db.collection('productos').add({
    'Nombre': nombre,
    'Categoria': categoria,
    'Precio': double.parse(precio),
  });
}


Future<void> updateProducto(
    String uid, String nombre, String categoria, String precio) async {
  
  // --- Sanitización ---
  nombre = nombre.trim();
  categoria = categoria.trim();
  precio = precio.trim();

  // --- Validaciones ---
  if (uid.isEmpty) {
    throw Exception("ID inválido.");
  }
  if (nombre.isEmpty || categoria.isEmpty || precio.isEmpty) {
    throw Exception("Todos los campos son obligatorios.");
  }
  if (double.tryParse(precio) == null) {
    throw Exception("El precio debe ser numérico.");
  }

  try {
    await db.collection('productos').doc(uid).update({
      'Nombre': nombre,
      'Categoria': categoria,
      'Precio': double.parse(precio),
    });
  } catch (e) {
    throw Exception("Error al actualizar producto: $e");
  }
}

Future<void> deleteProducto(String uid) async {
  if (uid.isEmpty) {
    throw Exception("ID inválido.");
  }

  try {
    await db.collection('productos').doc(uid).delete();
  } catch (e) {
    throw Exception("Error al eliminar producto: $e");
  }
}
