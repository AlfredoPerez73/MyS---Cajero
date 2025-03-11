import 'package:cajero_mys/views/Home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ATMApp());
}

class ATMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug
      title: 'Cajero Automático',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeView(), // Carga la vista principal del cajero
    );
  }
}
