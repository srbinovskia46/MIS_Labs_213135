// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:lab3/widgets/newExamDate.dart';
// import 'model/Exam.dart';
//
// class CalendarExams extends StatefulWidget {
//   static String id = "calendar_exams";
//
//   const CalendarExams({Key? key}) : super(key: key);
//
//   @override
//   _CalendarExamsState createState() => _CalendarExamsState();
// }
//
// class _CalendarExamsState extends State<CalendarExams> {
//   List<Exam> exams = [Exam(subject: "MIS", date: DateTime.now())];
//
//   void _addExamDateFunction() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return GestureDetector(
//           onTap: () {},
//           behavior: HitTestBehavior.opaque,
//           child: NewExamDate(
//             addDate: (newExam) {
//               setState(() {
//                 exams.add(newExam);
//               });
//               //id doesn't work properly with Navigator.pop(context)
//               //Navigator.pop(context); // Close the modal after adding the exam
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Exam Dates',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurpleAccent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             onPressed: () {
//               _addExamDateFunction();
//             },
//             icon: const Icon(Icons.add_circle_outline_sharp, color: Colors.white),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SfCalendar(
//           view: CalendarView.month, // Set the initial view
//           dataSource: ExamDataSource(exams), // Use your exams as the data source
//           onTap: (CalendarTapDetails details) {
//             // Handle tap events on the calendar if needed
//             // For example, show details for a specific date
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class ExamDataSource extends CalendarDataSource {
//   ExamDataSource(List<Exam> source) {
//     appointments = source.map((exam) {
//       return Appointment(
//         startTime: exam.date,
//         endTime: exam.date.add(const Duration(hours: 1)),
//         subject: exam.subject,
//         color: Colors.blue, // Customize event colors as needed
//       );
//     }).toList();
//   }
// }

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:lab3/widgets/newExamDate.dart'; // Import your NewExamDate widget here
import 'model/Exam.dart';

class CalendarExams extends StatefulWidget {
  static String id = "calendar_exams";

  const CalendarExams({Key? key}) : super(key: key);

  @override
  _CalendarExamsState createState() => _CalendarExamsState();
}

class _CalendarExamsState extends State<CalendarExams> {
  List<Exam> exams = [Exam(subject: "MIS", date: DateTime.now())];

  void _addExamDateFunction() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewExamDate(
            addDate: (newExam) {
              setState(() {
                exams.add(newExam);
              });
            },
          ),
        );
      },
    );
  }

  void _showDetails(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      DateTime tappedDate = details.date!;

      // Filter events for the tapped date
      List<Exam> eventsForTappedDate = exams.where((exam) {
        return exam.date.year == tappedDate.year &&
            exam.date.month == tappedDate.month &&
            exam.date.day == tappedDate.day;
      }).toList();

      // Show events in an AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Events for ${tappedDate.day}/${tappedDate.month}/${tappedDate.year}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventsForTappedDate.map((exam) {
                  return ListTile(
                    title: Text(exam.subject),
                    subtitle: Text(
                        '${exam.date.hour}:${exam.date.minute}'), // Customize display as needed
                    // Add more details if required
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Dates',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              _addExamDateFunction();
            },
            icon: const Icon(Icons.add_circle_outline_sharp, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SfCalendar(
          view: CalendarView.month, // Set the initial view
          dataSource: ExamDataSource(exams), // Use your exams as the data source
          onTap: _showDetails, // Call _showDetails method on calendar tap
        ),
      ),
    );
  }
}

class ExamDataSource extends CalendarDataSource {
  ExamDataSource(List<Exam> source) {
    appointments = source.map((exam) {
      return Appointment(
        startTime: exam.date,
        endTime: exam.date.add(const Duration(hours: 1)),
        subject: exam.subject,
        color: Colors.blue, // Customize event colors as needed
      );
    }).toList();
  }
}

