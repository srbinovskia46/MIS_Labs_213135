import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lab3/notification_controller.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:lab3/widgets/newExamDate.dart';
import 'model/Exam.dart';
import 'utils/exam_storage.dart';

class CalendarExams extends StatefulWidget {
  static String id = "calendar_exams";

  const CalendarExams({Key? key}) : super(key: key);

  @override
  _CalendarExamsState createState() => _CalendarExamsState();
}

class _CalendarExamsState extends State<CalendarExams> {
  List<Exam> exams = [];
  final ExamStorage examStorage = ExamStorage();

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    super.initState();
    loadExamData();
  }

  void loadExamData() async {
    List<Exam> storedExams = await examStorage.getExamDates();
    setState(() {
      exams = storedExams;
    });
  }

  // void _addExamDateFunction() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) {
  //       return GestureDetector(
  //         onTap: () {},
  //         behavior: HitTestBehavior.opaque,
  //         child: NewExamDate(
  //           addDate: (newExam) {
  //             setState(() {
  //               exams.add(newExam);
  //               examStorage.saveExamDates(exams);
  //               AwesomeNotifications().createNotification(
  //                   content: NotificationContent(
  //                       id: 1,
  //                       channelKey: "basic_channel",
  //                       title: newExam.subject,
  //                       body: newExam.date.toString()));
  //             });
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

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
                examStorage.saveExamDates(exams);

                // Calculate the notification time 5 seconds in the future
                DateTime examDate = newExam.date;
                DateTime notificationTime = examDate.add(const Duration(seconds: 5));
                //print(notificationTime);

                AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 1,
                    channelKey: "basic_channel",
                    title: newExam.subject,
                    body: newExam.date.toString(),
                    wakeUpScreen: true,
                    category: NotificationCategory.Reminder,
                  ),
                  schedule: NotificationCalendar.fromDate(date: notificationTime),);
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
            title: Text(
                'Events for ${tappedDate.day}/${tappedDate.month}/${tappedDate.year}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventsForTappedDate.map((exam) {
                  return ListTile(
                    title: Text(exam.subject),
                    subtitle: Text(
                        '${exam.date.hour}:${exam.date.minute}'), // Customize display as needed
                    // Add more details if required
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          exams.remove(exam);
                          examStorage.saveExamDates(exams); // Delete the exam
                        });
                        Navigator.of(context).pop(); // Close the dialog after deletion
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
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
          view: CalendarView.month,
          dataSource: ExamDataSource(exams),
          onTap: _showDetails,
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
        color: Colors.blue,
      );
    }).toList();
  }
}
