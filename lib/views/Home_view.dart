import 'package:flutter/material.dart';
import 'withdrawal_view2.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenido"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Column(
        children: [
          // Título principal
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "¿Qué podemos hacer hoy por ti?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Grid de opciones
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                OptionCard(
                  title: "Retirar \$10000",
                  icon: Icons.attach_money,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WithdrawalView()),
                    );
                  },
                ),
                OptionCard(
                  title: "Retirar \$20000",
                  icon: Icons.money,
                  onTap: () {},
                ),
                OptionCard(
                  title: "Retirar \$50000",
                  icon: Icons.attach_money,
                  onTap: () {},
                ),
                OptionCard(
                  title: "Retirar \$100000",
                  icon: Icons.money,
                  onTap: () {},
                ),
                OptionCard(
                  title: "Otra Cantidad",
                  icon: Icons.calculate,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WithdrawalView()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const OptionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
