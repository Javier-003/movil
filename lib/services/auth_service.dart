import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

/// Servicio de autenticación con Google
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Devuelve UserCredential si todo sale bien, o null si se cancela/ocurre error.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1) Selección de cuenta Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('DEBUG -> Google sign-in cancelado por el usuario');
        return null;
      }

      // 2) Datos públicos del user
      print('DEBUG -> googleUser.email: ${googleUser.email}');
      print('DEBUG -> googleUser.displayName: ${googleUser.displayName}');
      print('DEBUG -> googleUser.photoUrl: ${googleUser.photoUrl}');

      // 3) Tokens de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('DEBUG -> googleAuth.idToken: ${googleAuth.idToken}');       // SENSIBLE
      print('DEBUG -> googleAuth.accessToken: ${googleAuth.accessToken}'); // SENSIBLE

      // 4) (Opcional) Decodificar payload del idToken (solo mostrar en dev, no publicar)
      if (googleAuth.idToken != null) {
        try {
          final parts = googleAuth.idToken!.split('.');
          if (parts.length == 3) {
            final payload = base64Url.normalize(parts[1]);
            final decoded = utf8.decode(base64Url.decode(payload));
            print('DEBUG -> idToken payload: $decoded');
          }
        } catch (e) {
          print('DEBUG -> Error decodificando idToken: $e');
        }
      }

      // 5) Crear credenciales Firebase y autenticar
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print('DEBUG -> Firebase signInWithCredential user: ${userCredential.user?.email}');
      print('DEBUG -> Firebase UID: ${userCredential.user?.uid}');

      return userCredential;
    } catch (e) {
      print('DEBUG -> Error en signInWithGoogle: $e');
      return null;
    }
  }
}