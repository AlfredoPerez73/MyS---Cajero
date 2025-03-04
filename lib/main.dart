import 'package:flutter/material.dart';
import './views/withdrawal_view2.dart';

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
      home: WithdrawalView(), // Carga la vista principal del cajero
    );
  }
}
