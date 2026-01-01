import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weight_goal.dart';
import '../services/goal_service.dart';
import '../services/storage_service.dart';

class GoalScreen extends StatefulWidget {
  final String userName;

  const GoalScreen({super.key, required this.userName});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetWeightController = TextEditingController();
  final _targetDateController = TextEditingController();
  DateTime? _selectedDate;
  WeightGoal? _currentGoal;
  double? _currentWeight;
  bool _isLoading = true;
  bool _hasExistingGoal = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Cargar meta actual
    final goal = await GoalService.getGoal(widget.userName);
    
    // Cargar peso actual (último registro)
    final records = await StorageService.getRecordsByUser(widget.userName);
    if (records.isNotEmpty) {
      _currentWeight = records.first.peso;
    }

    if (goal != null) {
      setState(() {
        _currentGoal = goal;
        _hasExistingGoal = true;
        _targetWeightController.text = goal.targetWeight.toStringAsFixed(1);
        if (goal.targetDate != null) {
          _selectedDate = goal.targetDate;
          _targetDateController.text = DateFormat('dd/MM/yyyy').format(goal.targetDate!);
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _targetDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate() && _currentWeight != null) {
      final targetWeight = double.parse(_targetWeightController.text);
      
      final goal = WeightGoal(
        userName: widget.userName,
        targetWeight: targetWeight,
        initialWeight: _currentWeight!,
        createdAt: _currentGoal?.createdAt ?? DateTime.now(),
        targetDate: _selectedDate,
      );

      await GoalService.saveGoal(goal);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_hasExistingGoal 
                ? 'Meta actualizada exitosamente'
                : 'Meta establecida exitosamente'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _deleteGoal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar meta'),
        content: const Text('¿Estás seguro de eliminar esta meta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await GoalService.deleteGoal(widget.userName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meta eliminada'),
            backgroundColor: Color(0xFFFF9800),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void dispose() {
    _targetWeightController.dispose();
    _targetDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Meta de Peso'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meta de Peso'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: _hasExistingGoal
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Eliminar meta',
                  onPressed: _deleteGoal,
                ),
              ]
            : null,
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
                  // Información actual
                  if (_currentWeight != null) ...[
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monitor_weight,
                                  size: 32,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Peso actual',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '${_currentWeight!.toStringAsFixed(1)} kg',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Meta de peso objetivo
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Peso Objetivo',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _targetWeightController,
                            decoration: InputDecoration(
                              labelText: 'Peso objetivo (kg)',
                              prefixIcon: const Icon(Icons.track_changes),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF4A4A4A)
                                  : Colors.grey.shade50,
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa el peso objetivo';
                              }
                              final weight = double.tryParse(value);
                              if (weight == null || weight <= 0) {
                                return 'Peso inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _targetDateController,
                            decoration: InputDecoration(
                              labelText: 'Fecha objetivo (opcional)',
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF4A4A4A)
                                  : Colors.grey.shade50,
                            ),
                            readOnly: true,
                            onTap: _selectDate,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Botón guardar
                  ElevatedButton.icon(
                    onPressed: _saveGoal,
                    icon: const Icon(Icons.save, size: 24),
                    label: Text(
                      _hasExistingGoal ? 'Actualizar Meta' : 'Establecer Meta',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

