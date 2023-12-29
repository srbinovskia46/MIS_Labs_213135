import 'package:shared_preferences/shared_preferences.dart';

import '../model/Exam.dart';

class ExamStorage {
  static const _keyExamDates = 'exam_dates';

  Future<void> saveExamDates(List<Exam> exams) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> examData = exams.map((exam) => exam.toJsonString()).toList();
    await prefs.setStringList(_keyExamDates, examData);
  }

  Future<List<Exam>> getExamDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final examData = prefs.getStringList(_keyExamDates);
    if (examData != null) {
      return examData.map((data) => Exam.fromJsonString(data)).toList();
    } else {
      return [];
    }
  }
}
