import 'package:flutter/material.dart';
import '../controllers/withdrawal_controller.dart';

class WithdrawalView extends StatefulWidget {
  @override
  _WithdrawalViewState createState() => _WithdrawalViewState();
}

class _WithdrawalViewState extends State<WithdrawalView> {
  final WithdrawalController controller = WithdrawalController();
  final TextEditingController amountController = TextEditingController();
  Map<int, int>? billDistribution;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 10),
              const Text("Ingrese un monto válido"),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
      setState(() {
        billDistribution = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cajero Automático - Solo Retiro",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(125, 68, 143, 255),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Input con bordes redondeados
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Ingrese el monto a retirar",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                fillColor: const Color.fromARGB(134, 238, 238, 238),
                filled: true,
                prefixIcon: const Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Botón de Retirar
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

            // 🔹 Verificar si hay resultados
            if (billDistribution != null && billDistribution!.isNotEmpty) ...[
              const Text(
                "Distribución de billetes:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 🔹 Lista de tarjetas con cada tipo de billete
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
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 68, 137, 255),
                                  Color.fromARGB(255, 61, 103, 143),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.monetization_on,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Billetes de \$$billValue",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // 🔹 Mostrar cantidad de billetes en un badge
                                  Chip(
                                    label: Text(
                                      "x$count",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: const Color.fromARGB(
                                      223,
                                      56,
                                      142,
                                      60,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              // 🔹 Mostrar el total retirado en una tarjeta elegante
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // 🔹 Ajusta el valor para más o menos redondez
                  ),
                  title: const Text(
                    "Total retirado",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
