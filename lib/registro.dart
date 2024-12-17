import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_flutter2/FirstScreen.dart';
import 'package:login_flutter2/select_image.dart';
import 'package:login_flutter2/upload_image.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key});

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  File? imageToUpload;
  TextEditingController nameController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Material App"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final image = await getImage();
              setState(() {
                imageToUpload = File(image!.path);
              });
            },
            child: Text("Seleccionar imagen"),
          ),
          ElevatedButton(
            onPressed: () async {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp2()),
              );
              // Subir imagen a Firebase Storage
              String datos= dataController.text;
              String nombre=nameController.text;
              final uploaded = await uploadImage(imageToUpload!, nombre, datos);
              if (imageToUpload == null) {

              }
              if (uploaded==true) {
                // Obtener la URL de la imagen subida
                String imageUrl = (await getImage()) as String;

                // Guardar el nombre, datos y URL de la imagen en Firestore
                await saveImageData(
                    nameController.text, dataController.text, imageUrl);

                // Mostrar un mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("Imagen y datos subidos correctamente")),
                );
              } else {
                // Mostrar un mensaje de error si la subida falló
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al subir la imagen")),
                );
              }
            },

            child: Text("Subir a Firebase"),

          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: dataController,
              decoration: InputDecoration(
                labelText: "Datos",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          imageToUpload != null
              ? Image.file(imageToUpload!)
              : Container(
                  margin: EdgeInsets.all(10),
                  height: 100,
                  width: double.infinity,
                  color: Colors.red,
                ),
        ],
      )),
    );
  }

  saveImageData(String nombre, String datos, String imageUrl) {}
}
