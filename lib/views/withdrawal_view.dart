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
          content: Text("Ingrese un monto válido"),
          backgroundColor: Colors.red,
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
        title: Text("Cajero Automático", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                prefixIcon: Icon(Icons.money),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: withdrawMoney,
              icon: Icon(Icons.account_balance_wallet),
              label: Text("Retirar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            SizedBox(height: 20),
            if (result != null)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Distribución de billetes:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: result!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Icon(
                                Icons.monetization_on,
                                color: Colors.green,
                              ),
                              title: Text(
                                result![index].where((e) => e > 0).join(" - "),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
