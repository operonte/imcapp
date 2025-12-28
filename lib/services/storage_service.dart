import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/imc_record.dart';

class StorageService {
  static const String _recordsKey = 'imc_records';

  // Guardar un registro de IMC
  static Future<void> saveRecord(IMCRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.add(record);
    
    final recordsJson = records.map((r) => r.toJson()).toList();
    await prefs.setString(_recordsKey, jsonEncode(recordsJson));
  }

  // Obtener todos los registros
  static Future<List<IMCRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsString = prefs.getString(_recordsKey);
    
    if (recordsString == null) {
      return [];
    }
    
    final List<dynamic> recordsJson = jsonDecode(recordsString);
    return recordsJson.map((json) => IMCRecord.fromJson(json)).toList();
  }

  // Obtener registros de un usuario específico
  static Future<List<IMCRecord>> getRecordsByUser(String userName) async {
    final allRecords = await getRecords();
    return allRecords.where((r) => r.userName == userName).toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha)); // Más recientes primero
  }

  // Obtener lista de usuarios únicos
  static Future<List<String>> getUsers() async {
    final records = await getRecords();
    final users = records.map((r) => r.userName).toSet().toList();
    users.sort();
    return users;
  }

  // Eliminar un registro
  static Future<void> deleteRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.removeWhere((r) => r.id == id);
    
    final recordsJson = records.map((r) => r.toJson()).toList();
    await prefs.setString(_recordsKey, jsonEncode(recordsJson));
  }

  // Eliminar todos los registros de un usuario
  static Future<void> deleteUserRecords(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getRecords();
    records.removeWhere((r) => r.userName == userName);
    
    final recordsJson = records.map((r) => r.toJson()).toList();
    await prefs.setString(_recordsKey, jsonEncode(recordsJson));
  }
}

