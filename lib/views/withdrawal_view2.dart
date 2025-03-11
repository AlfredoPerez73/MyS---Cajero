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
  bool isDarkMode = false;

  void withdrawMoney() {
    int? amount = int.tryParse(amountController.text);
    if (amount != null && amount > 0) {
      setState(() {
        billDistribution = _calculateBillDistribution(amount);
      });
    } else {
      _showErrorDialog();
      setState(() => billDistribution = null);
    }
  }

  Map<int, int> _calculateBillDistribution(int amount) {
    List<List<int>> result = controller.getRedistribution(amount);
    Map<int, int> groupedBills = {};
    for (var row in result) {
      for (var bill in row) {
        if (bill > 0) {
          groupedBills[bill] = (groupedBills[bill] ?? 0) + 1;
        }
      }
    }
    return groupedBills;
  }

  void _showErrorDialog() {
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
  }

  void toggleDarkMode() => setState(() => isDarkMode = !isDarkMode);

  @override
  Widget build(BuildContext context) {
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
              _buildTextField(),
              const SizedBox(height: 16),
              _buildWithdrawButton(),
              const SizedBox(height: 20),
              if (billDistribution != null && billDistribution!.isNotEmpty)
                _buildBillDistributionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Colors.black54 : Colors.white,
        hintText: "Ingrese el monto a retirar",
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildWithdrawButton() {
    return ElevatedButton.icon(
      onPressed: withdrawMoney,
      icon: const Icon(Icons.account_balance_wallet),
      label: const Text("Retirar"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }

  Widget _buildBillDistributionList() {
    if (billDistribution == null || billDistribution!.isEmpty) {
      return const SizedBox(); // Retorna un contenedor vacío si no hay datos
    }

    return Expanded(
      child: ListView(
        children:
            billDistribution!.entries.map((entry) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 4,
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                child: ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: Text(
                    "Billetes de \${entry.key}",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  trailing: Chip(
                    label: Text("x\${entry.value}"),
                    backgroundColor: Colors.green,
                  ),
                ),
              );
            }).toList(), // Se agrega solo si hay datos
      ),
    );
  }

  Widget _buildTotalCard() {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
          "\\${billDistribution!.entries.map((e) => e.key * e.value).reduce((a, b) => a + b)}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
