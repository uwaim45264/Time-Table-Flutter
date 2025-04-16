import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/timetable.dart';

class TimetableProvider with ChangeNotifier {
  List<Timetable> _timetables = [];

  List<Timetable> get timetables => _timetables;

  TimetableProvider() {
    loadTimetables();
  }

  Future<void> loadTimetables() async {
    _timetables = await DatabaseHelper.instance.getTimetables();
    notifyListeners();
  }

  Future<void> addTimetable(Timetable timetable) async {
    await DatabaseHelper.instance.insertTimetable(timetable);
    await loadTimetables();
  }

  Future<void> updateTimetable(Timetable timetable) async {
    await DatabaseHelper.instance.updateTimetable(timetable);
    await loadTimetables();
  }

  Future<void> deleteTimetable(int id) async {
    await DatabaseHelper.instance.deleteTimetable(id);
    await loadTimetables();
  }
}