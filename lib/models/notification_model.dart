// import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String image;
  final DateTime time;
  final String type;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.image,
    required this.time,
    required this.type,
    required this.isRead,
  });

  // factory NotificationModel.fromJson(Map<String, dynamic> json) {
  //   return NotificationModel(
  //     title: json["title"],
  //     image: json["image"],
  //     time: json["time"],
  //     type: json["type"],
  //   );
  // }
}
