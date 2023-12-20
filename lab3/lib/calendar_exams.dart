import 'package:flutter/material.dart';
import 'package:lab3/widgets/newExamDate.dart';

import 'model/Exam.dart';

class CalendarExams extends StatefulWidget {
  static String id = "calendar_exams";

  const CalendarExams({Key? key}) : super(key: key);

  @override
  _CalendarExamsState createState() => _CalendarExamsState();
}

class _CalendarExamsState extends State<CalendarExams> {
  List<Exam> exams = [];

  void _addExamDateFunction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewExamDate(
                addDate: (newExam){
                  setState(() {
                    exams.add(newExam);
                  });
                },
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Dates',
            style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurpleAccent,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Display the AddExamScreen in a bottom sheet when the add button is pressed
              _addExamDateFunction();
            },
            icon: const Icon(Icons.add_circle_outline_sharp, color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: exams.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Do something when a card is tapped
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        exams[index].subject,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${exams[index].date.day}/${exams[index].date.month}/${exams[index].date.year}\n${exams[index].date.hour}:${exams[index].date.minute}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement delete functionality here
                          setState(() {
                            exams.removeAt(index);
                          });
                        },
                        child: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
