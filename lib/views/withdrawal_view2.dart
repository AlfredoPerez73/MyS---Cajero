import 'package:flutter/material.dart';
import '../controllers/withdrawal_controller.dart';

Widget _buildOptionCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class WithdrawalView extends StatefulWidget {
  @override
  _WithdrawalViewState createState() => _WithdrawalViewState();
}

class _WithdrawalViewState extends State<WithdrawalView> {
  final WithdrawalController controller = WithdrawalController();
  final TextEditingController amountController = TextEditingController();
  Map<int, int>? billDistribution;
  bool isDarkMode = false;

  void withdrawMoney() {
    int? amount = int.tryParse(amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        List<List<int>> result = controller.getRedistribution(amount);

        // 🔹 Agrupar los billetes y contar cuántos hay de cada denominación
        Map<int, int> groupedBills = {};
        for (var row in result) {
          for (var bill in row) {
            if (bill > 0) {
              groupedBills[bill] = (groupedBills[bill] ?? 0) + 1;
            }
          }
        }
        billDistribution = groupedBills;
      });
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.redAccent,
              title: Row(
                children: const [
                  Icon(Icons.warning, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text("Error", style: TextStyle(color: Colors.white)),
                ],
              ),
              content: const Text(
                "Ingrese un monto válido para el retiro.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
      );

      setState(() {
        billDistribution = null;
      });
    }
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? _errorText;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Retiro de Dinero", style: TextStyle(fontSize: 22)),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 4,
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: toggleDarkMode,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color:
                      isDarkMode
                          ? Colors.white
                          : Colors.black, // Color del texto
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      isDarkMode
                          ? Colors.black54
                          : Colors.white, // Fondo del input
                  hintText: "Ingrese el monto a retirar",
                  hintStyle: TextStyle(
                    color:
                        isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[700], // Color del hint
                  ),
                  errorText: _errorText, // Mensaje de error si hay un problema
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color:
                          isDarkMode
                              ? Colors.white
                              : Colors.black, // Color del borde
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color:
                          isDarkMode
                              ? Colors.grey
                              : Colors
                                  .black, // Color del borde cuando está habilitado
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(
                      color:
                          Colors
                              .blueAccent, // Color cuando el input está activo
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: withdrawMoney,
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text("Retirar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (billDistribution != null && billDistribution!.isNotEmpty) ...[
                const Text(
                  "Distribución de billetes:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children:
                        billDistribution!.entries.map((entry) {
                          int billValue = entry.key;
                          int count = entry.value;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(
                                Icons.monetization_on,
                                color: Colors.blueAccent,
                                size: 30,
                              ),
                              title: Text("Billetes de \$$billValue"),
                              trailing: Chip(
                                label: Text("x$count"),
                                backgroundColor: Colors.green,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
                Card(
                  color: Colors.green.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                      size: 30,
                    ),
                    title: const Text(
                      "Total retirado",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      "\$${billDistribution!.entries.map((e) => e.key * e.value).reduce((a, b) => a + b)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
