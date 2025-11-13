import 'package:cloud_firestore/cloud_firestore.dart';

// instancia de Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

// CRUD de productos en Firestore
Future<List> getproductos() async {
  List productos = [];
  CollectionReference collectionReference = db.collection('productos');
  QuerySnapshot queryproductos = await collectionReference.get();
  queryproductos.docs.forEach((documentos) {
    productos.add(documentos.data());
    productos.last['id'] = documentos.id;
  });
  return productos;
}

Future<void> insertproducto(
    String nombre, String categoria, String precio) async {
  await db.collection('productos').add({
    'Nombre': nombre,
    'Categoria': categoria,
    'Precio': precio,
  });
}

Future<void> updateproducto(
    String uid, String nombre, String categoria, String precio) async {
  await db.collection('productos').doc(uid).update({
    'Nombre': nombre,
    'Categoria': categoria,
    'Precio': precio,
  });
}

Future<void> deleteproducto(String uid) async {
  await db.collection('productos').doc(uid).delete();
}
