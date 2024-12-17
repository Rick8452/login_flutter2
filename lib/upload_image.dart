import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<bool> uploadImage(File image, String nombre, String datos) async {
  try {
    // Subir la imagen a Storage
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String namefile = image.path.split("/").last;
    final Reference ref = storage.ref().child("libros").child(namefile);
    final UploadTask uploadTask = ref.putFile(image);
    final TaskSnapshot snapshot = await uploadTask;
    final String url = await snapshot.ref.getDownloadURL();

    // Guardar la URL y otros datos en Firestore
    await firestore.collection('Libros').add({
      'Imagen': url,
      'Nombre': nombre,
      'Datos ': datos,
      // Otros datos que quieras guardar
    });

    return true;
  } catch (e) {
    print('Error al subir la imagen: $e');
    return false;
  }
}
