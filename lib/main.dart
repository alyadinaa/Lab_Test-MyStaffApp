import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart'; // <- Make sure it's imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBhejaU-nB3EimnFLthMhOrzW1QAxvnf-o",
      authDomain: "labtest-mystaffapp.firebaseapp.com",
      projectId: "labtest-mystaffapp",
      storageBucket: "labtest-mystaffapp.appspot.com",
      messagingSenderId: "742498293467",
      appId: "1:742498293467:web:cc8569afc06ef2aadedefe",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyStaff',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // <- Use SplashScreen here
      debugShowCheckedModeBanner: false,
    );
  }
}
