import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';
import '../../provider/notifications.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NtProvider ntProvider = Provider.of<NtProvider>(context, listen: false);
    List<NotificationModel> notifications = ntProvider.notifications;

    return RefreshIndicator(
      onRefresh: ntProvider.getNotifications,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          actions: [
            IconButton(
              onPressed: () async {
                ntProvider.addNotification(
                  "Su vanası çalıştı",
                  "image",
                  "urgent",
                  true,
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
          title: Text(
            "Bildirimler",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.abel().fontFamily,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            notifications = context.watch<NtProvider>().notifications;

            NotificationModel nt = notifications[index];

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                // color: Colors.grey[900],
                // color: Colors.grey[900],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Dismissible(
                onDismissed: (direction) {
                  ntProvider.removeNotificationFromFirebase(nt.id);
                },
                key: Key(nt.id),
                child: Card(
                  child: ListTile(
                    // Write indexes to leading
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.notoSans().fontFamily,
                        ),
                      ),
                    ),
                    // Add Dates to subtitle
                    subtitle: Text(
                      "${nt.time.day}/${nt.time.month}/${nt.time.year} ${nt.time.hour}:${nt.time.minute} ${nt.time.second}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.notoSans().fontFamily,
                      ),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor:
                          nt.type == "urgent" ? Colors.red : Colors.transparent,
                      child: Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {},
                    title: Text(
                      nt.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.notoSans().fontFamily,
                      ),
                    ),
                    // trailing: Icon(
                    //   nt.type == "urgent" ? Icons.warning : Icons.info,
                    //   color: nt.type == "urgent" ? Colors.amber : Colors.green,
                    // ),
                  ),
                ),
              ),
            );
          },
          itemCount: context.watch<NtProvider>().notifications.length,
        ),
      ),
    );
  }
}
