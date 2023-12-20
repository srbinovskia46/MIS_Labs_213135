import 'dart:convert';

class Exam {
  final String subject;
  final DateTime date;

  Exam({required this.subject, required this.date});

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'date': date.toIso8601String()};
  }

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      subject: json['subject'],
      date: DateTime.parse(json['date']),
    );
  }

  String toJsonString() {
    return '{"subject": "$subject", "date": "${date.toIso8601String()}"}';
  }

  factory Exam.fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Exam(
      subject: json['subject'],
      date: DateTime.parse(json['date']),
    );
  }
}
