import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/imc_record.dart';
import '../models/weight_goal.dart';
import '../services/storage_service.dart';
import '../services/export_service.dart';
import '../services/goal_service.dart';
import 'history_screen.dart';
import 'statistics_screen.dart';
import 'home_screen.dart';
import 'goal_screen.dart';

class SavedUsersScreen extends StatefulWidget {
  const SavedUsersScreen({super.key});

  @override
  State<SavedUsersScreen> createState() => _SavedUsersScreenState();
}

class _SavedUsersScreenState extends State<SavedUsersScreen> {
  List<String> _users = [];
  Map<String, List<IMCRecord>> _userRecords = {};
  Map<String, WeightGoal> _userGoals = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    final users = await StorageService.getUsers();
    final Map<String, List<IMCRecord>> userRecordsMap = {};
    final Map<String, WeightGoal> goalsMap = {};

    for (final user in users) {
      final records = await StorageService.getRecordsByUser(user);
      if (records.isNotEmpty) {
        userRecordsMap[user] = records;
      }
      
      // Cargar meta del usuario
      final goal = await GoalService.getGoal(user);
      if (goal != null) {
        goalsMap[user] = goal;
      }
    }

    setState(() {
      _users = users;
      _userRecords = userRecordsMap;
      _userGoals = goalsMap;
      _isLoading = false;
    });
  }

  IMCRecord? _getLatestRecord(String userName) {
    final records = _userRecords[userName];
    if (records == null || records.isEmpty) return null;
    return records.first; // Ya están ordenados por fecha descendente
  }

  Color _getCategoriaColor(String categoria) {
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

  Future<void> _deleteUser(String userName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text(
          '¿Estás seguro de eliminar todos los registros de "$userName"?',
        ),
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
      await StorageService.deleteUserRecords(userName);
      _loadUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registros de "$userName" eliminados'),
            backgroundColor: const Color(0xFFFF9800), // Naranja suave
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Guardados'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _users.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No hay usuarios guardados',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crea un nuevo registro para comenzar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadUsers,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final userName = _users[index];
                        final latestRecord = _getLatestRecord(userName);
                        final recordCount = _userRecords[userName]?.length ?? 0;
                        final dateFormat = DateFormat('dd/MM/yyyy');

                        if (latestRecord == null) return const SizedBox();

                        final categoriaColor =
                            _getCategoriaColor(latestRecord.categoria);

                        final goal = _userGoals[userName];
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 6,
                          shadowColor: categoriaColor.withValues(alpha: 0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryScreen(
                                    selectedUser: userName,
                                  ),
                                ),
                              ).then((_) => _loadUsers());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1976D2)
                                                    .withValues(alpha: 0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                color: Color(0xFF1976D2),
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userName,
                                                    style: const TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                      color: Color(0xFF1976D2),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '$recordCount registro${recordCount != 1 ? 's' : ''}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline),
                                            color: Colors.orange.shade400,
                                            tooltip: 'Agregar nuevos datos',
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(
                                                    userName: userName,
                                                  ),
                                                ),
                                              ).then((_) => _loadUsers());
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.flag),
                                            color: Colors.purple.shade400,
                                            tooltip: 'Meta de peso',
                                            onPressed: () async {
                                              final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GoalScreen(
                                                    userName: userName,
                                                  ),
                                                ),
                                              );
                                              if (result == true) {
                                                _loadUsers();
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.bar_chart),
                                            color: Colors.blue.shade400,
                                            tooltip: 'Estadísticas',
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StatisticsScreen(
                                                    userName: userName,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.share),
                                            color: Colors.green.shade300,
                                            tooltip: 'Exportar',
                                            onPressed: () async {
                                              if (!mounted) return;
                                              final messenger = ScaffoldMessenger.of(context);
                                              try {
                                                await ExportService.exportUserData(
                                                    userName);
                                                if (mounted) {
                                                  messenger.showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Datos exportados exitosamente'),
                                                      backgroundColor: Color(0xFF4CAF50), // Verde suave
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  messenger.showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Error: ${e.toString()}'),
                                                      backgroundColor: const Color(0xFFE57373), // Rojo suave
                                                      behavior: SnackBarBehavior.floating,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline),
                                            color: Colors.red.shade300,
                                            tooltip: 'Eliminar',
                                            onPressed: () => _deleteUser(userName),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: categoriaColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildStatItem(
                                          'IMC Actual',
                                          latestRecord.imc.toStringAsFixed(1),
                                          categoriaColor,
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.grey.shade300,
                                        ),
                                        _buildStatItem(
                                          'Peso',
                                          '${latestRecord.peso.toStringAsFixed(1)} kg',
                                          Colors.grey.shade700,
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.grey.shade300,
                                        ),
                                        _buildStatItem(
                                          'Altura',
                                          '${(latestRecord.altura * 100).toStringAsFixed(0)} cm',
                                          Colors.grey.shade700,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Meta de peso (si existe)
                                  if (goal != null) ...[
                                    const SizedBox(height: 12),
                                    _buildGoalProgress(goal, latestRecord.peso),
                                  ],
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: categoriaColor.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: categoriaColor.withValues(alpha: 0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          latestRecord.categoria,
                                          style: TextStyle(
                                            color: categoriaColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Último: ${dateFormat.format(latestRecord.fecha)}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        latestRecord.genero == 'Hombre'
                                            ? Icons.male
                                            : Icons.female,
                                        size: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${latestRecord.genero}, ${latestRecord.edad} años',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalProgress(WeightGoal goal, double currentWeight) {
    final progress = goal.calculateProgress(currentWeight);
    final remaining = goal.calculateRemaining(currentWeight);
    final isOnTrack = goal.isOnTrack(currentWeight);
    final difference = goal.calculateDifference(currentWeight);
    final isGaining = goal.targetWeight > goal.initialWeight;
    
    final progressColor = isOnTrack 
        ? (isGaining ? Colors.blue : Colors.green)
        : Colors.orange;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: Colors.purple.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Meta de Peso',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
              const Spacer(),
              Text(
                '${goal.targetWeight.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 10,
              backgroundColor: Colors.purple.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isOnTrack ? Icons.trending_up : Icons.trending_flat,
                    size: 16,
                    color: isOnTrack ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isGaining 
                        ? '+${difference.toStringAsFixed(1)} kg'
                        : '${difference.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Text(
                '${remaining.toStringAsFixed(1)} kg restantes',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

