class WithdrawalModel {
  List<int> montos = [
    10000,
    20000,
    50000,
    100000,
  ]; // Denominaciones de billetes

  List<List<int>> redistribuir(int valor) {
    List<List<int>> matriz = [];
    int acumulador = 0;
    int inicio = 0;

    while (acumulador < valor) {
      List<int> fila = List.filled(montos.length, 0);
      for (int j = inicio; j < montos.length; j++) {
        if (acumulador + montos[j] <= valor) {
          fila[j] = montos[j];
          acumulador += montos[j];
        }
      }
      matriz.add(fila);

      inicio++;
      if (inicio >= montos.length) {
        inicio = 0;
      }
    }

    return matriz;
  }
}
