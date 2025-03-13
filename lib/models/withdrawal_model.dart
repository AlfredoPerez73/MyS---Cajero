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

  // Método para contar billetes por denominación
  Map<int, int> contarBilletes(List<List<int>> matriz) {
    Map<int, int> conteo = {};
    for (var denominacion in montos) {
      conteo[denominacion] = 0;
    }

    for (var fila in matriz) {
      for (int i = 0; i < fila.length; i++) {
        if (fila[i] > 0) {
          conteo[montos[i]] = (conteo[montos[i]] ?? 0) + 1;
        }
      }
    }

    return conteo;
  }

  // Método para obtener la descripción textual de los billetes
  List<String> obtenerDescripcionBilletes(int valor) {
    List<List<int>> matriz = redistribuir(valor);
    Map<int, int> conteo = contarBilletes(matriz);

    List<String> descripcion = [];
    conteo.forEach((denominacion, cantidad) {
      if (cantidad > 0) {
        descripcion.add('$cantidad billetes de ${denominacion.toString()}');
      }
    });

    return descripcion;
  }

  // Método para predecir retiros posibles
  int predecirRetirosPosibles(int valor) {
    // Estimación simple basada en el valor del retiro
    return (200000 ~/ valor) + 1;
  }
}
