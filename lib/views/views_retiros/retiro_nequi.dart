import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import '../../models/withdrawal_model.dart';

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
  String _claveGenerada = '';
  bool _isLoading = false;
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

  // Genera una clave aleatoria de 6 dígitos
  String _generarClave() {
    final random = Random();
    String clave = '';
    for (int i = 0; i < 6; i++) {
      clave += random.nextInt(10).toString();
    }
    return clave;
  }

  void _verificarCelular() {
    // Get the cleaned phone number
    String celular = _celularController.text.trim();

    // Check basic format (10 digits, numbers only)
    if (celular.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(celular)) {
      _mostrarError(
        'El número de celular debe tener 10 dígitos y solo números.',
      );
      return;
    }

    // Check if it's a valid Colombian mobile number
    // Colombian mobile numbers start with 3
    if (!celular.startsWith('3')) {
      _mostrarError(
        'El número de celular debe comenzar con 3 para ser válido en Colombia.',
      );
      return;
    }

    // Check second digit (Colombian carriers mostly use 0-5)
    int secondDigit = int.parse(celular[1]);
    if (secondDigit > 5) {
      _mostrarError(
        'El número de celular parece no corresponder a una operadora válida en Colombia.',
      );
      return;
    }

    // Mostrar animación de carga
    setState(() {
      _isLoading = true;
    });

    // Simular un tiempo de carga
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _claveGenerada = _generarClave();
      });

      // Mostrar modal con la clave dinámica
      _mostrarModalClave();
      _iniciarContador();
    });
  }

  void _mostrarModalClave() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Clave Dinámica', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ingrese la siguiente clave para continuar:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade300),
                  ),
                  child: Text(
                    _claveGenerada,
                    style: const TextStyle(
                      fontSize: 28,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Válida por $_countdown segundos',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _claveController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Ingrese la clave de 6 dígitos',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _timer?.cancel();
                    _mostrarClave = false;
                  });
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _verificarClaveIngresada();
                },
                child: const Text('Verificar'),
              ),
            ],
          ),
    );
  }

  void _verificarClaveIngresada() {
    // Verifica que la clave ingresada coincida con la generada
    String clave = _claveController.text.trim();
    if (clave == _claveGenerada) {
      setState(() {
        _claveIngresada = true;
        // Generar código de 11 dígitos (añadiendo un 0 al inicio del número celular)
        _codigoGenerado = '0${_celularController.text}';
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      _mostrarError('La clave ingresada no es correcta.');
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
        child:
            _isLoading
                ? _buildLoadingView()
                : _claveIngresada
                ? _buildSeleccionMontoView()
                : _buildIngresoCelularView(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue, strokeWidth: 5),
          const SizedBox(height: 24),
          Text(
            'Validando tu número...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngresoCelularView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ingrese su número de celular',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Necesitamos validar tu número para enviar una clave dinámica.',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _celularController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Ej. 3001234567',
                  prefixIcon: const Icon(Icons.phone_android),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.blue.shade700,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _verificarCelular,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Continuar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSeleccionMontoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Validación exitosa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Código generado: $_codigoGenerado',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Seleccione valor a retirar:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: widget.retirosFijos.length + 1, // +1 for "Otro" button
            itemBuilder: (context, index) {
              if (index < widget.retirosFijos.length) {
                final retiro = widget.retirosFijos[index];
                return ElevatedButton(
                  onPressed:
                      () => _seleccionarValor(retiro['valor'].toString()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade800,
                  ),
                  child: Text(
                    retiro['nombre'],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              } else {
                // "Otro" button
                return ElevatedButton(
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
                              prefixText: '\$ ',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade50,
                    foregroundColor: Colors.orange.shade800,
                  ),
                  child: const Text(
                    'Otro valor',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
