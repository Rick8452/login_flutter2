import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db= FirebaseFirestore.instance;

Future<List> getLibros() async{
  List libros = [];
  CollectionReference collectionReferenceLibros = db.collection('Libros');
  QuerySnapshot queryLibros = await collectionReferenceLibros.get();
  queryLibros.docs.forEach((documento) {
    libros.add(documento.data());
  });
  return libros;
}