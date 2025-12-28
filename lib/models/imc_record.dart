class IMCRecord {
  final String id;
  final String userName;
  final double peso; // en kilogramos
  final double altura; // en metros
  final int edad;
  final String genero; // 'Hombre' o 'Mujer'
  final DateTime fecha;
  final double imc;
  final String categoria;

  IMCRecord({
    required this.id,
    required this.userName,
    required this.peso,
    required this.altura,
    required this.edad,
    required this.genero,
    required this.fecha,
    required this.imc,
    required this.categoria,
  });

  // Calcular IMC
  static double calcularIMC(double peso, double altura) {
    if (altura <= 0) return 0;
    return peso / (altura * altura);
  }

  // Obtener categoría según IMC
  static String obtenerCategoria(double imc) {
    if (imc < 18.5) {
      return 'Bajo peso';
    } else if (imc < 25) {
      return 'Peso normal';
    } else if (imc < 30) {
      return 'Sobrepeso';
    } else {
      return 'Obesidad';
    }
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'peso': peso,
      'altura': altura,
      'edad': edad,
      'genero': genero,
      'fecha': fecha.toIso8601String(),
      'imc': imc,
      'categoria': categoria,
    };
  }

  // Crear desde JSON
  factory IMCRecord.fromJson(Map<String, dynamic> json) {
    return IMCRecord(
      id: json['id'] as String,
      userName: json['userName'] as String,
      peso: (json['peso'] as num).toDouble(),
      altura: (json['altura'] as num).toDouble(),
      edad: json['edad'] as int,
      genero: json['genero'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      imc: (json['imc'] as num).toDouble(),
      categoria: json['categoria'] as String,
    );
  }
}

