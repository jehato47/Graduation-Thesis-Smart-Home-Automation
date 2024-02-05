import '../models/notification_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NtProvider extends ChangeNotifier {
  List<NotificationModel> notifications = [];
  int unReadCount = 0;
  // = [
  //   NotificationModel(
  //     title: "Mutfak ışıkları açıldı",
  //     image: "image",
  //     time: DateTime.now(),
  //     type: "urgent1",
  //     isRead: true,
  //   ),
  //   NotificationModel(
  //     title: "Gaz Sensörüde Yüksek Değer Algılandı",
  //     image: "image",
  //     time: DateTime.now(),
  //     type: "urgent",
  //     isRead: true,
  //   ),
  //   NotificationModel(
  //     title: "Su sensörüde Yüksek Değer Algılandı ve Su Vanası Kapatıldı",
  //     image: "image",
  //     time: DateTime.now(),
  //     type: "urgent",
  //     isRead: true,
  //   ),
  //   NotificationModel(
  //     title: "Sıcaklık sensörüde Yüksek Değer Algılandı",
  //     image: "image",
  //     time: DateTime.now(),
  //     type: "urgent",
  //     isRead: true,
  //   ),
  // ];
  Future<void> getNotifications() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("notifications");
    DataSnapshot snapshot = await ref.get();

    notifications.clear();

    //   DataSnapshot snapshot = await ref.get();

    Object values2 = snapshot.value as Object;
    Map<String, dynamic> values = Map<String, Object>.from(values2 as Map);

    values2.entries.forEach((entry) {
      dynamic value = entry.value;
      notifications.add(
        NotificationModel(
          id: value["id"],
          title: value["title"],
          image: value["image"],
          time: DateTime.fromMillisecondsSinceEpoch(value["time"]),
          type: value["type"],
          isRead: value["isRead"],
        ),
      );
    });

    // Order notifications according to date
    notifications.sort((a, b) => b.time.compareTo(a.time));

    getCountOfUnreadNotifications();
    notifyListeners();
    print(notifications[0].title);
  }

  void getCountOfUnreadNotifications() {
    int count = 0;
    notifications.forEach((element) {
      if (!element.isRead) {
        count++;
      }
    });
    unReadCount = count;
    print(count);
  }

  Future<void> addNotification([
    String? title,
    String? image,
    // int? time,
    String? type,
    bool? isRead,
  ]) async {
    DateTime currentDate = DateTime.now();
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("notifications").push();

    await ref.set({
      "id": ref.key,
      "title": title,
      "image": image,
      "time": currentDate.millisecondsSinceEpoch,
      "type": type,
      "isRead": isRead,
    });

    // also add notification to notifications list
    notifications.add(
      NotificationModel(
        id: ref.toString(),
        title: title as String,
        image: image as String,
        time: currentDate,
        type: type as String,
        isRead: isRead as bool,
      ),
    );

    // sort notifications according to date
    notifications.sort((a, b) => b.time.compareTo(a.time));
    notifyListeners();
  }

  Future<void> removeNotificationFromFirebase(String id) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("notifications").child(id);

    await ref.remove();

    // also remove notification from notifications list
    notifications.removeWhere((element) => element.id == id);
    // notifyListeners();
  }

  void removeNotification(NotificationModel notification) {
    notifications.remove(notification);
  }

  void clearNotifications() {
    notifications.clear();
  }
}
