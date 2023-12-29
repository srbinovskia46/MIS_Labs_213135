import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:lab3/model/Exam.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/Location.dart';
import 'location_service.dart';

class NotificationService {
  int idCount = 0;
  bool locationNotifActive = false;
  Location finki = Location("FINKI", 42.004186212873655, 21.409531941596985);
  DateTime? lastNotificationTime;

  NotificationService() {

    // Start checking location periodically
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (!locationNotifActive) {
        checkLocationAndNotify();
      }
    });
  }

  void scheduleNotificationsForExams(exams) {
    for (int i = 0; i < exams.length; i++) {
      scheduleNotification(exams[i]);
    }
  }

  void scheduleNotification(Exam exam) {
    final int notificationId = idCount++;

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: "basic_channel",
        title: exam.subject,
        body: "You have an exam tomorrow!",
      ),
      schedule: NotificationCalendar(
        day: exam.date.subtract(const Duration(days: 1)).day,
        month: exam.date.subtract(const Duration(days: 1)).month,
        year: exam.date.subtract(const Duration(days: 1)).year,
        hour: exam.date.subtract(const Duration(days: 1)).hour,
        minute: exam.date.subtract(const Duration(days: 1)).minute,
      ),
    );
  }

  Future<void> toggleLocationNotification() async {
    locationNotifActive = !locationNotifActive;

    if (locationNotifActive) {
      // If notifications are activated, immediately check location
      checkLocationAndNotify();
    }
  }

  Future<void> checkLocationAndNotify() async {
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      bool theSameLocation = false;
      LocationService().getCurrentLocation().then((value) {
        if ((value.latitude < finki.latitude + 0.01 && value.latitude > finki.latitude - 0.01) &&
            (value.longitude < finki.longitude + 0.01 && value.longitude > finki.longitude - 0.01)) {
          theSameLocation = true;
        }
        if (theSameLocation && canSendNotification()) {
          // Trigger notification
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: idCount++,
              channelKey: "basic_channel",
              title: "Get Ready!",
              body: "You have exams soon!",
            ),
          );
          // Set the lastNotificationTime to the current time
          lastNotificationTime = DateTime.now();
        }
      });
    }
  }

  bool canSendNotification() {
    // Check if lastNotificationTime is null or more than 10 minutes ago
    return lastNotificationTime == null ||
        DateTime.now().difference(lastNotificationTime!) > const Duration(minutes: 10);
  }


}
