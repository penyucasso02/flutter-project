import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 // Import HomeScreen
import 'package:mysafes/screens/login_screen.dart'; // Import LoginScreen

void main() async {

WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  name: 'mysafesfirebsase',
  options: FirebaseOptions(apiKey: "AIzaSyCobrq03Yww1xcBsTyE3yt1PoGNspmpya0",
  authDomain: "mysafes-a8bfd.firebaseapp.com",
  databaseURL: "https://mysafes-a8bfd-default-rtdb.firebaseio.com",
  projectId: "mysafes-a8bfd",
  storageBucket: "mysafes-a8bfd.firebasestorage.app",
  messagingSenderId: "104068660131",
  appId: "1:104068660131:web:6d09151cbffd04ba757816"));


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MySafe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Start with the LoginScreen
    );
  }
}
