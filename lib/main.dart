import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_img.dart';
import 'FirstScreen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Platform.isAndroid ?
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyBvu8kUphPhvICTsCmKryW4YFhrQNGkWC0',
            appId: '1:365694737933:android:aa2ace760aae1f19ff3f44',
            messagingSenderId: '365694737933',
            projectId: 'login-flutter2',
            storageBucket: "login-flutter2.appspot.com"
        )): await Firebase.initializeApp();

    runApp(MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );

  }

}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signinButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signinButton() {
    return OutlinedButton(
      onPressed: () {
        signWithGoogle().whenComplete(() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return MyApp2();
          }));
        });
      },
      style: OutlinedButton.styleFrom(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        side: BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/google_logo.png'),
              height: 35.0,
            ),
            SizedBox(width: 10),
            Text(
              "Sign in with Google",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
