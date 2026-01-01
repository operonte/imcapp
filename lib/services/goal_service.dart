import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weight_goal.dart';

class GoalService {
  static const String _goalsKey = 'weight_goals';

  // Guardar meta de un usuario
  static Future<void> saveGoal(WeightGoal goal) async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getString(_goalsKey);
    
    Map<String, dynamic> goalsMap = {};
    if (goalsJson != null) {
      goalsMap = json.decode(goalsJson) as Map<String, dynamic>;
    }
    
    goalsMap[goal.userName] = goal.toJson();
    
    await prefs.setString(_goalsKey, json.encode(goalsMap));
  }

  // Obtener meta de un usuario
  static Future<WeightGoal?> getGoal(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getString(_goalsKey);
    
    if (goalsJson == null) return null;
    
    final goalsMap = json.decode(goalsJson) as Map<String, dynamic>;
    final goalJson = goalsMap[userName];
    
    if (goalJson == null) return null;
    
    return WeightGoal.fromJson(goalJson as Map<String, dynamic>);
  }

  // Eliminar meta de un usuario
  static Future<void> deleteGoal(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getString(_goalsKey);
    
    if (goalsJson == null) return;
    
    final goalsMap = json.decode(goalsJson) as Map<String, dynamic>;
    goalsMap.remove(userName);
    
    await prefs.setString(_goalsKey, json.encode(goalsMap));
  }

  // Obtener todas las metas
  static Future<Map<String, WeightGoal>> getAllGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getString(_goalsKey);
    
    if (goalsJson == null) return {};
    
    final goalsMap = json.decode(goalsJson) as Map<String, dynamic>;
    final result = <String, WeightGoal>{};
    
    goalsMap.forEach((userName, goalJson) {
      result[userName] = WeightGoal.fromJson(goalJson as Map<String, dynamic>);
    });
    
    return result;
  }
}

