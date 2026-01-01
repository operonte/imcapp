class WeightGoal {
  final String userName;
  final double targetWeight; // Peso objetivo en kg
  final double initialWeight; // Peso inicial cuando se estableció la meta
  final DateTime createdAt; // Fecha en que se estableció la meta
  final DateTime? targetDate; // Fecha objetivo opcional

  WeightGoal({
    required this.userName,
    required this.targetWeight,
    required this.initialWeight,
    required this.createdAt,
    this.targetDate,
  });

  // Calcular progreso (porcentaje)
  double calculateProgress(double currentWeight) {
    if (targetWeight == initialWeight) return 100.0;
    
    final totalChange = (targetWeight - initialWeight).abs();
    final currentChange = (currentWeight - initialWeight).abs();
    
    if (totalChange == 0) return 100.0;
    
    final progress = (currentChange / totalChange) * 100;
    return progress.clamp(0.0, 100.0);
  }

  // Calcular cuánto falta para la meta
  double calculateRemaining(double currentWeight) {
    return (targetWeight - currentWeight).abs();
  }

  // Determinar si se está cumpliendo la meta (si está yendo en la dirección correcta)
  bool isOnTrack(double currentWeight) {
    if (targetWeight > initialWeight) {
      // Meta es subir de peso
      return currentWeight >= initialWeight;
    } else {
      // Meta es bajar de peso
      return currentWeight <= initialWeight;
    }
  }

  // Calcular diferencia desde el inicio
  double calculateDifference(double currentWeight) {
    return currentWeight - initialWeight;
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'targetWeight': targetWeight,
      'initialWeight': initialWeight,
      'createdAt': createdAt.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
    };
  }

  // Crear desde JSON
  factory WeightGoal.fromJson(Map<String, dynamic> json) {
    return WeightGoal(
      userName: json['userName'] as String,
      targetWeight: (json['targetWeight'] as num).toDouble(),
      initialWeight: (json['initialWeight'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
    );
  }
}

