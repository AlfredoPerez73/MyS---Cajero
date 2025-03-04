import '../models/withdrawal_model.dart';

class WithdrawalController {
  final WithdrawalModel model = WithdrawalModel();

  List<List<int>> getRedistribution(int amount) {
    return model.redistribuir(amount);
  }
}
