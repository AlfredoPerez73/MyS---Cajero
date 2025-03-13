import 'package:flutter/material.dart';
import 'package:cajero_mys/views/views_retiros/retiro_ahorro_a_la_mano.dart';
import 'package:cajero_mys/views/views_retiros/retiro_cuenta_ahorro.dart';
import 'package:cajero_mys/views/views_retiros/retiro_nequi.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> retirosFijos = [
    {'valor': 20000, 'nombre': '20.000'},
    {'valor': 50000, 'nombre': '50.000'},
    {'valor': 100000, 'nombre': '100.000'},
    {'valor': 200000, 'nombre': '200.000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicación de Retiros'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Seleccione tipo de retiro',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Escoja una de las siguientes opciones para realizar su retiro',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 40),
                _buildRetiroOption(
                  context,
                  icon: Icons.phone_android,
                  title: 'Retiro por número de celular',
                  subtitle: 'Retiro con tu número NEQUI',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                RetiroCelularScreen(retirosFijos: retirosFijos),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildRetiroOption(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Retiro estilo ahorro a la mano',
                  subtitle: 'Con código de 11 dígitos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RetiroAhorroManoScreen(
                              retirosFijos: retirosFijos,
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildRetiroOption(
                  context,
                  icon: Icons.account_balance,
                  title: 'Retiro por cuenta de ahorros',
                  subtitle: 'Con número de cuenta',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RetiroCuentaAhorrosScreen(
                              retirosFijos: retirosFijos,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetiroOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
