import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicación de Retiros',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF3B82F6),
          tertiary: const Color(0xFF0284C7),
          surface: Colors.white,
          background: const Color(0xFFF8FAFC),
        ),
        textTheme: GoogleFonts.nunitoSansTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1E3A8A),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

// Modelo de retiro usando la lógica de redistribución proporcionada
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> retirosFijos = [
    {'valor': 20000, 'nombre': '20.000'},
    {'valor': 50000, 'nombre': '50.000'},
    {'valor': 100000, 'nombre': '100.000'},
    {'valor': 200000, 'nombre': '200.000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicación de Retiros'), elevation: 0),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Seleccione tipo de retiro',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Escoja una de las siguientes opciones para realizar su retiro',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 40),
                _buildRetiroOption(
                  context,
                  icon: Icons.phone_android,
                  title: 'Retiro por número de celular',
                  subtitle: 'Retiro con tu número NEQUI',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                RetiroCelularScreen(retirosFijos: retirosFijos),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildRetiroOption(
                  context,
                  icon: Icons.account_balance_wallet,
                  title: 'Retiro estilo ahorro a la mano',
                  subtitle: 'Con código de 11 dígitos',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RetiroAhorroManoScreen(
                              retirosFijos: retirosFijos,
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildRetiroOption(
                  context,
                  icon: Icons.account_balance,
                  title: 'Retiro por cuenta de ahorros',
                  subtitle: 'Con número de cuenta',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RetiroCuentaAhorrosScreen(
                              retirosFijos: retirosFijos,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRetiroOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla para el retiro por número de celular (NEQUI)
class RetiroCelularScreen extends StatefulWidget {
  final List<Map<String, dynamic>> retirosFijos;

  const RetiroCelularScreen({Key? key, required this.retirosFijos})
    : super(key: key);

  @override
  _RetiroCelularScreenState createState() => _RetiroCelularScreenState();
}

class _RetiroCelularScreenState extends State<RetiroCelularScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final WithdrawalModel _withdrawalModel = WithdrawalModel();
  String _valorSeleccionado = '';
  bool _mostrarClave = false;
  int _countdown = 60;
  Timer? _timer;
  bool _claveIngresada = false;
  String _codigoGenerado = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _celularController.dispose();
    _claveController.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _iniciarContador() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          _mostrarClave = false;
          _claveIngresada = false;
        }
      });
    });
  }

  void _verificarCelular() {
    // Verifica que el número de celular tenga 10 dígitos y solo números
    String celular = _celularController.text.trim();
    if (celular.length == 10 && RegExp(r'^[0-9]+$').hasMatch(celular)) {
      setState(() {
        _mostrarClave = true;
        _iniciarContador();
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      _mostrarError(
        'El número de celular debe tener 10 dígitos y solo números.',
      );
    }
  }

  void _verificarClave() {
    // Verifica que la clave tenga 6 dígitos
    String clave = _claveController.text.trim();
    if (clave.length == 6 && RegExp(r'^[0-9]+$').hasMatch(clave)) {
      setState(() {
        _claveIngresada = true;
        // Generar código de 11 dígitos (añadiendo un 0 al inicio del número celular)
        _codigoGenerado = '0${_celularController.text}';
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      _mostrarError('La clave debe tener 6 dígitos y solo números.');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  void _seleccionarValor(String valor) {
    setState(() {
      _valorSeleccionado = valor;
    });

    // Verificar si es 145000
    if (valor == '145000') {
      _mostrarError(
        'No se puede retirar 145000, inicie nuevamente el proceso.',
      );
      Navigator.pop(context);
      return;
    }

    // Mostrar la cantidad de billetes usando el método redistribuir
    _mostrarDetalleBilletes(int.parse(valor));
  }

  void _mostrarDetalleBilletes(int valor) {
    List<String> descripcionBilletes = _withdrawalModel
        .obtenerDescripcionBilletes(valor);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detalle de Billetes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...descripcionBilletes.map((desc) => Text(desc)).toList(),
                const SizedBox(height: 20),
                Text('Código de retiro: $_codigoGenerado'),
                const SizedBox(height: 10),
                Text(
                  'Retiros posibles: ${_withdrawalModel.predecirRetirosPosibles(valor)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Finalizar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retiro por número de celular (NEQUI)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_claveIngresada) ...[
              const Text(
                'Ingrese su número de celular (10 dígitos):',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _celularController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'Ej. 3001234567'),
                enabled: !_mostrarClave,
              ),
              if (!_mostrarClave)
                ElevatedButton(
                  onPressed: _verificarCelular,
                  child: const Text('Continuar'),
                ),
              if (_mostrarClave) ...[
                Text(
                  'Ingrese su clave de 6 dígitos (Tiempo restante: $_countdown segundos):',
                  style: const TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: _claveController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  obscureText: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Ingrese su clave',
                  ),
                ),
                ElevatedButton(
                  onPressed: _verificarClave,
                  child: const Text('Verificar clave'),
                ),
              ],
            ] else ...[
              Text(
                'Código generado: $_codigoGenerado',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccione valor a retirar:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...widget.retirosFijos
                      .map(
                        (retiro) => ElevatedButton(
                          onPressed:
                              () =>
                                  _seleccionarValor(retiro['valor'].toString()),
                          child: Text(retiro['nombre']),
                        ),
                      )
                      .toList(),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: const Text('Ingrese valor a retirar'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Valor',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    _seleccionarValor(controller.text);
                                  }
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Otro'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Pantalla para el retiro estilo ahorro a la mano
class RetiroAhorroManoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> retirosFijos;

  const RetiroAhorroManoScreen({Key? key, required this.retirosFijos})
    : super(key: key);

  @override
  _RetiroAhorroManoScreenState createState() => _RetiroAhorroManoScreenState();
}

class _RetiroAhorroManoScreenState extends State<RetiroAhorroManoScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final WithdrawalModel _withdrawalModel = WithdrawalModel();
  String _valorSeleccionado = '';
  bool _claveIngresada = false;
  String _codigoGenerado = '';

  @override
  void dispose() {
    _numeroController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  void _verificarNumero() {
    // Verificar el vector de 11 dígitos que comienza con 0 o 1
    String numero = _numeroController.text.trim();

    if (numero.length == 11 &&
        RegExp(r'^[01][0-9]+$').hasMatch(numero) &&
        RegExp(r'^[01][2-9][0-9]*$').hasMatch(numero) &&
        !RegExp(r'[a-zA-Z!@#$%^&*(),.?":{}|<>]').hasMatch(numero)) {
      // Mostrar diálogo para ingresar clave
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ingrese su clave de 4 dígitos'),
            content: TextField(
              controller: _claveController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'Clave de 4 dígitos'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (_claveController.text.length == 4 &&
                      RegExp(r'^[0-9]+$').hasMatch(_claveController.text)) {
                    Navigator.pop(context);
                    setState(() {
                      _claveIngresada = true;
                      _codigoGenerado = _numeroController.text;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La clave debe tener 4 dígitos y solo números.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Verificar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El número debe ser de 11 dígitos, comenzar con 0 o 1, tener segundo dígito entre 2 y 9, y no incluir caracteres alfabéticos o especiales.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _seleccionarValor(String valor) {
    setState(() {
      _valorSeleccionado = valor;
    });

    // Verificar si es 145000
    if (valor == '145000') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede retirar 145000, inicie nuevamente el proceso.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
      return;
    }

    // Mostrar la cantidad de billetes usando el método redistribuir
    _mostrarDetalleBilletes(int.parse(valor));
  }

  void _mostrarDetalleBilletes(int valor) {
    List<String> descripcionBilletes = _withdrawalModel
        .obtenerDescripcionBilletes(valor);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detalle de Billetes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...descripcionBilletes.map((desc) => Text(desc)).toList(),
                const SizedBox(height: 20),
                Text('Código de retiro: $_codigoGenerado'),
                const SizedBox(height: 10),
                Text(
                  'Retiros posibles: ${_withdrawalModel.predecirRetirosPosibles(valor)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Finalizar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retiro estilo ahorro a la mano')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_claveIngresada) ...[
              const Text(
                'Ingrese el número de 11 dígitos:',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                '(Debe empezar con 0 o 1, el segundo dígito debe ser entre 2 y 9)',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              TextField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'Ej. 01234567890'),
              ),
              ElevatedButton(
                onPressed: _verificarNumero,
                child: const Text('Continuar'),
              ),
            ] else ...[
              Text(
                'Código generado: $_codigoGenerado',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccione valor a retirar:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...widget.retirosFijos
                      .map(
                        (retiro) => ElevatedButton(
                          onPressed:
                              () =>
                                  _seleccionarValor(retiro['valor'].toString()),
                          child: Text(retiro['nombre']),
                        ),
                      )
                      .toList(),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: const Text('Ingrese valor a retirar'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Valor',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    _seleccionarValor(controller.text);
                                  }
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Otro'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Pantalla para el retiro por cuenta de ahorros
class RetiroCuentaAhorrosScreen extends StatefulWidget {
  final List<Map<String, dynamic>> retirosFijos;

  const RetiroCuentaAhorrosScreen({Key? key, required this.retirosFijos})
    : super(key: key);

  @override
  _RetiroCuentaAhorrosScreenState createState() =>
      _RetiroCuentaAhorrosScreenState();
}

class _RetiroCuentaAhorrosScreenState extends State<RetiroCuentaAhorrosScreen> {
  final TextEditingController _numeroCuentaController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final WithdrawalModel _withdrawalModel = WithdrawalModel();
  String _valorSeleccionado = '';
  bool _claveIngresada = false;
  String _codigoGenerado = '';

  @override
  void dispose() {
    _numeroCuentaController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  void _verificarNumeroCuenta() {
    // Verificar número de cuenta de 11 dígitos
    String numeroCuenta = _numeroCuentaController.text.trim();

    if (numeroCuenta.length == 11 &&
        RegExp(r'^[0-9]+$').hasMatch(numeroCuenta) &&
        !RegExp(r'[a-zA-Z!@#$%^&*(),.?":{}|<>]').hasMatch(numeroCuenta)) {
      // Mostrar diálogo para ingresar clave
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ingrese su clave de 4 dígitos'),
            content: TextField(
              controller: _claveController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'Clave de 4 dígitos'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (_claveController.text.length == 4 &&
                      RegExp(r'^[0-9]+$').hasMatch(_claveController.text)) {
                    Navigator.pop(context);
                    setState(() {
                      _claveIngresada = true;
                      _codigoGenerado = _numeroCuentaController.text;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'La clave debe tener 4 dígitos y solo números.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Verificar'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El número de cuenta debe ser de 11 dígitos y no incluir caracteres alfabéticos o especiales.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _seleccionarValor(String valor) {
    setState(() {
      _valorSeleccionado = valor;
    });

    // Verificar si es 145000
    if (valor == '145000') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede retirar 145000, inicie nuevamente el proceso.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
      return;
    }

    // Mostrar la cantidad de billetes usando el método redistribuir
    _mostrarDetalleBilletes(int.parse(valor));
  }

  void _mostrarDetalleBilletes(int valor) {
    List<String> descripcionBilletes = _withdrawalModel
        .obtenerDescripcionBilletes(valor);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detalle de Billetes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...descripcionBilletes.map((desc) => Text(desc)).toList(),
                const SizedBox(height: 20),
                Text('Código de retiro: $_codigoGenerado'),
                const SizedBox(height: 10),
                Text(
                  'Retiros posibles: ${_withdrawalModel.predecirRetirosPosibles(valor)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Finalizar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retiro por cuenta de ahorros')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_claveIngresada) ...[
              const Text(
                'Ingrese el número de cuenta (11 dígitos):',
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _numeroCuentaController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: 'Ej. 12345678901'),
              ),
              ElevatedButton(
                onPressed: _verificarNumeroCuenta,
                child: const Text('Continuar'),
              ),
            ] else ...[
              Text(
                'Código generado: $_codigoGenerado',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccione valor a retirar:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...widget.retirosFijos
                      .map(
                        (retiro) => ElevatedButton(
                          onPressed:
                              () =>
                                  _seleccionarValor(retiro['valor'].toString()),
                          child: Text(retiro['nombre']),
                        ),
                      )
                      .toList(),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: const Text('Ingrese valor a retirar'),
                            content: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                hintText: 'Valor',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    _seleccionarValor(controller.text);
                                  }
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Otro'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
