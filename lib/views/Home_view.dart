import 'package:flutter/material.dart';
import 'withdrawal_view2.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Bienvenido"),
          centerTitle: true,
          backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
          elevation: 4,
          actions: [
            Switch(
              value: isDarkMode,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Título principal
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "¿Qué podemos hacer hoy por ti?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
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
                    title: "Retirar \$10,000",
                    icon: Icons.attach_money,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WithdrawalView(),
                        ),
                      );
                    },
                  ),
                  OptionCard(
                    title: "Retirar \$20,000",
                    icon: Icons.money,
                    isDarkMode: isDarkMode,
                    onTap: () {},
                  ),
                  OptionCard(
                    title: "Retirar \$50,000",
                    icon: Icons.attach_money,
                    isDarkMode: isDarkMode,
                    onTap: () {},
                  ),
                  OptionCard(
                    title: "Retirar \$100,000",
                    icon: Icons.money,
                    isDarkMode: isDarkMode,
                    onTap: () {},
                  ),
                  OptionCard(
                    title: "Otra Cantidad",
                    icon: Icons.calculate,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WithdrawalView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDarkMode;

  const OptionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black45 : Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDarkMode ? Colors.white : Colors.blueAccent,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
