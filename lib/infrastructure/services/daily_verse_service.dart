import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:webradiooasis/core/models/daily_verse.dart';

class DailyVerseService {
  static List<DailyVerse> _verses = [];
  static bool _isLoaded = false;

  static Future<void> loadVerses() async {
    if (_isLoaded) return;
    
    try {
      // Cargar el archivo JSON usando rootBundle
      final String jsonString = await rootBundle.loadString('assets/verses.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Convertir JSON a objetos DailyVerse
      _verses = jsonList.map((json) => DailyVerse.fromJson(json)).toList();
      _isLoaded = true;
    } catch (e) {
      print('Error loading verses: $e');
      _verses = [];
      _isLoaded = false;
      rethrow; // Propagar el error para mejor manejo
    }
  }

  static Future<DailyVerse> getRandomVerse() async {
    if (!_isLoaded) {
      await loadVerses();
    }
    
    if (_verses.isEmpty) {
      throw Exception('No verses available');
    }

    final List<DailyVerse> tempVerses = List.from(_verses);
    tempVerses.shuffle();
    return tempVerses.first;
  }

  static Future<DailyVerse> getDailyVerse() async {
    if (!_isLoaded) {
      await loadVerses();
    }
    
    if (_verses.isEmpty) {
      throw Exception('No verses available');
    }

    final today = DateTime.now();
    final index = today.day % _verses.length;
    return _verses[index];
  }

  // Método para limpiar el caché si es necesario
  static void clearCache() {
    _verses = [];
    _isLoaded = false;
  }
}