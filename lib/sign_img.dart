import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn= GoogleSignIn();

Future<String> signWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      // El usuario canceló el inicio de sesión
      return 'Inicio de sesión cancelado';
    }

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      print("Hola, el usuario es $user");
      return 'Accedido como ${user.displayName ?? user.email ?? user.uid}';
    } else {
      return 'Error al iniciar sesión';
    }
  } catch (e) {
    print("Error al iniciar sesión con Google: $e");
    return 'Error al iniciar sesión';
  }
}
