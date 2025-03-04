import 'package:flutter/material.dart';
import '../controllers/withdrawal_controller.dart';

class WithdrawalView extends StatefulWidget {
  @override
  _WithdrawalViewState createState() => _WithdrawalViewState();
}

class _WithdrawalViewState extends State<WithdrawalView> {
  final WithdrawalController controller = WithdrawalController();
  final TextEditingController amountController = TextEditingController();
  List<List<int>>? result;

  void withdrawMoney() {
    int? amount = int.tryParse(amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        result = controller.getRedistribution(amount);
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
            borderRadius: BorderRadius.circular(
              20,
            ), // 🔹 Hacemos la alerta más redonda
          ),
        ),
      );
      setState(() {
        result = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cajero Automático", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Input con bordes redondeados y fondo gris claro
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Ingrese el monto a retirar",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                fillColor: Colors.grey[200],
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
            if (result != null) ...[
              const Text(
                "Distribución de billetes:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 🔹 Lista de billetes en tarjetas
              Expanded(
                child: ListView.builder(
                  itemCount: result!.length,
                  itemBuilder: (context, index) {
                    final row = result![index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(
                          Icons.monetization_on,
                          color: Colors.green,
                        ),
                        title: Text(
                          row.where((e) => e > 0).join(" - "),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Mostrar el total retirado en una tarjeta
              Card(
                color: Colors.green.shade50,
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.green,
                  ),
                  title: const Text("Total retirado"),
                  subtitle: Text(
                    "\$${result!.expand((e) => e).reduce((a, b) => a + b)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
