import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/homepage.dart';
import 'firebase_options.dart';
import 'package:sqflite/sqflite.dart';  
import 'dart:developer';
import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
