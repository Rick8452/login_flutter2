import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_flutter2/registro.dart';

void main() {
  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Future<void> _deleteBook(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('Libros').doc(documentId).delete();
      print('Documento eliminado correctamente');
    } catch (error) {
      print('Error al eliminar el documento: $error');
    }
  }
  void _refreshData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Actualizando datos...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Forzar la recarga de los datos de Firestore
    FirebaseFirestore.instance.collection('Libros').get().then((snapshot) {
      // Actualizar la interfaz de usuario
      // Esto ejecutará el constructor de StreamBuilder nuevamente y mostrará los datos actualizados
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $error'),
          duration: Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Libros'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage2()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh), // Botón de actualización
            onPressed: () => _refreshData(context), // Llama al método _refreshData
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Libros').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay libros disponibles.'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var libro = snapshot.data!.docs[index];
                var nombre = libro['Nombre'];
                var datos = libro['Datos '];

                // Verificar si el campo "Imagen" existe en el documento antes de acceder a él
                var imageData = libro.data();
                var imageUrl = '';
                var documentId = libro.id;

                if (imageData is Map<String, dynamic> && imageData.containsKey('Imagen')) {
                  imageUrl = libro['Imagen'];
                }

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mostrar la imagen solo si imageUrl no está vacío
                      if (imageUrl.isNotEmpty)
                        Image.network(imageUrl),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              datos,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _deleteBook(documentId),
                        child: Text('Eliminar'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }

        },
      ),
    );
  }
}

class RegistroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Libro'),
      ),
      body: Center(
        child: Text('Pantalla de Registro'),
      ),
    );
  }
}

