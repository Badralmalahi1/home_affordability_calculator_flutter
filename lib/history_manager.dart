import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_affordability_profile.dart';

class HistoryManager {
  static const _historyKey = 'homeAffordabilityHistory';

  static Future<void> saveProfile(HomeAffordabilityProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];

    history.insert(0, jsonEncode(profile.toJson()));
    if (history.length > 5) history.removeLast();

    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<HomeAffordabilityProfile>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];

    return history
        .map((jsonStr) => HomeAffordabilityProfile.fromJson(jsonDecode(jsonStr)))
        .toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

