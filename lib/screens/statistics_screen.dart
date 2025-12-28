import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/imc_record.dart';
import '../services/storage_service.dart';

class StatisticsScreen extends StatefulWidget {
  final String userName;

  const StatisticsScreen({super.key, required this.userName});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<IMCRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await StorageService.getRecordsByUser(widget.userName);
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  double _getAverageIMC() {
    if (_records.isEmpty) return 0;
    final sum = _records.map((r) => r.imc).reduce((a, b) => a + b);
    return sum / _records.length;
  }

  double _getAverageWeight() {
    if (_records.isEmpty) return 0;
    final sum = _records.map((r) => r.peso).reduce((a, b) => a + b);
    return sum / _records.length;
  }

  String _getTrend() {
    if (_records.length < 2) return 'Sin datos suficientes';
    final first = _records.last.imc;
    final last = _records.first.imc;
    final diff = last - first;
    if (diff > 0.5) return 'Subiendo';
    if (diff < -0.5) return 'Bajando';
    return 'Estable';
  }

  // Para IMC: intervalo de 5, mostrar 3 arriba y 3 abajo
  double _getIMCMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    // Usar el valor promedio como centro
    final center = (minValue + maxValue) / 2;
    // Redondear hacia abajo al múltiplo de 5 más cercano
    final base = (center / 5).floor() * 5;
    // 3 intervalos hacia abajo (3 * 5 = 15)
    return ((base - 15).clamp(0.0, double.infinity)).toDouble();
  }

  double _getIMCMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 50;
    final minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    // Usar el valor promedio como centro
    final center = (minValue + maxValue) / 2;
    // Redondear hacia arriba al múltiplo de 5 más cercano
    final base = (center / 5).ceil() * 5;
    // 3 intervalos hacia arriba (3 * 5 = 15)
    return base + 15;
  }

  // Para Peso: intervalo de 10, mostrar 3 arriba y 3 abajo
  double _getWeightMinY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    final minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    // Usar el valor promedio como centro
    final center = (minValue + maxValue) / 2;
    // Redondear hacia abajo al múltiplo de 10 más cercano
    final base = (center / 10).floor() * 10;
    // 3 intervalos hacia abajo (3 * 10 = 30)
    return ((base - 30).clamp(0.0, double.infinity)).toDouble();
  }

  double _getWeightMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 150;
    final minValue = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxValue = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    // Usar el valor promedio como centro
    final center = (minValue + maxValue) / 2;
    // Redondear hacia arriba al múltiplo de 10 más cercano
    final base = (center / 10).ceil() * 10;
    // 3 intervalos hacia arriba (3 * 10 = 30)
    return base + 30;
  }

  Color _getTrendColor() {
    final trend = _getTrend();
    if (trend == 'Subiendo') return Colors.orange;
    if (trend == 'Bajando') return Colors.green;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_records.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Estadísticas - ${widget.userName}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('No hay suficientes registros para mostrar estadísticas'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas - ${widget.userName}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecords,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen de estadísticas
              _buildStatsCards(),
              const SizedBox(height: 24),
              // Gráfico de IMC
              _buildIMCChart(),
              const SizedBox(height: 24),
              // Gráfico de Peso
              _buildWeightChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Promedio IMC',
            _getAverageIMC().toStringAsFixed(1),
            Icons.trending_up,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Promedio Peso',
            '${_getAverageWeight().toStringAsFixed(1)} kg',
            Icons.monitor_weight,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Tendencia',
            _getTrend(),
            Icons.show_chart,
            _getTrendColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIMCChart() {
    final spots = _records.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.imc);
    }).toList();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evolución del IMC',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              value.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 9,
                                color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                              ),
                            ),
                          );
                        },
                        interval: 5.0, // Intervalo fijo de 5 para IMC
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: _getIMCMinY(spots),
                  maxY: _getIMCMaxY(spots),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    final spots = _records.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.peso);
    }).toList();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evolución del Peso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              value.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 9,
                                color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                              ),
                            ),
                          );
                        },
                        interval: 10.0, // Intervalo fijo de 10 para peso
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minY: _getWeightMinY(spots),
                  maxY: _getWeightMaxY(spots),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
