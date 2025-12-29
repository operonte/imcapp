import 'package:flutter/material.dart';
import '../models/imc_record.dart';
import '../services/storage_service.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _edadController = TextEditingController();
  String _genero = 'Hombre';
  double? _imcCalculado;
  String? _categoriaCalculada;

  @override
  void dispose() {
    _nameController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  void _calcularIMC() {
    if (_formKey.currentState!.validate()) {
      final peso = double.tryParse(_pesoController.text);
      final altura = double.tryParse(_alturaController.text) ?? 0;
      final alturaMetros = altura / 100; // Convertir cm a metros

      if (peso != null && alturaMetros > 0) {
        final imc = IMCRecord.calcularIMC(peso, alturaMetros);
        final categoria = IMCRecord.obtenerCategoria(imc);

        setState(() {
          _imcCalculado = imc;
          _categoriaCalculada = categoria;
        });
      }
    }
  }

  Future<void> _guardarRegistro() async {
    if (_formKey.currentState!.validate() && _imcCalculado != null) {
      final peso = double.parse(_pesoController.text);
      final altura = double.parse(_alturaController.text) / 100;
      final edad = int.parse(_edadController.text);

      final record = IMCRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: _nameController.text.trim(),
        peso: peso,
        altura: altura,
        edad: edad,
        genero: _genero,
        fecha: DateTime.now(),
        imc: _imcCalculado!,
        categoria: _categoriaCalculada!,
      );

      await StorageService.saveRecord(record);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registro guardado exitosamente'),
            backgroundColor: const Color(0xFF4CAF50), // Verde suave
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Limpiar formulario
        _pesoController.clear();
        _alturaController.clear();
        _edadController.clear();
        setState(() {
          _imcCalculado = null;
          _categoriaCalculada = null;
        });
      }
    }
  }

  Color _getCategoriaColor(String? categoria) {
    switch (categoria) {
      case 'Bajo peso':
        return Colors.blue;
      case 'Peso normal':
        return Colors.green;
      case 'Sobrepeso':
        return Colors.orange;
      case 'Obesidad':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora IMC'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 28),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    const Color(0xFF353535),
                    const Color(0xFF424242),
                  ]
                : [
                    Colors.blue.shade50,
                    Colors.teal.shade50,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor ingresa tu nombre';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _pesoController,
                            decoration: InputDecoration(
                              labelText: 'Peso (kg)',
                              prefixIcon: const Icon(Icons.monitor_weight),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu peso';
                              }
                              final peso = double.tryParse(value);
                              if (peso == null || peso <= 0) {
                                return 'Peso inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _alturaController,
                            decoration: InputDecoration(
                              labelText: 'Altura (cm)',
                              prefixIcon: const Icon(Icons.height),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu altura';
                              }
                              final altura = double.tryParse(value);
                              if (altura == null || altura <= 0) {
                                return 'Altura inválida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _edadController,
                            decoration: InputDecoration(
                              labelText: 'Edad',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu edad';
                              }
                              final edad = int.tryParse(value);
                              if (edad == null || edad <= 0 || edad > 150) {
                                return 'Edad inválida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            initialValue: _genero,
                            decoration: InputDecoration(
                              labelText: 'Género',
                              prefixIcon: const Icon(Icons.people),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Hombre',
                                child: Text('Hombre'),
                              ),
                              DropdownMenuItem(
                                value: 'Mujer',
                                child: Text('Mujer'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _genero = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _calcularIMC,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child: const Text(
                              'Calcular IMC',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_imcCalculado != null) ...[
                    const SizedBox(height: 30),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getCategoriaColor(_categoriaCalculada),
                              _getCategoriaColor(
                                _categoriaCalculada,
                              ).withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const Text(
                              'Tu IMC es:',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _imcCalculado!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _categoriaCalculada!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _guardarRegistro,
                              icon: const Icon(Icons.save),
                              label: const Text('Guardar Registro'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _getCategoriaColor(
                                  _categoriaCalculada,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
