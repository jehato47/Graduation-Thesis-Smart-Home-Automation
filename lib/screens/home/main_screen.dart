import 'ControlItemsList.dart';
import '../notification/notification_screen.dart';
import "package:flutter/material.dart";

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: NetworkImage(
          //     "https://scontent.fuab1-1.fna.fbcdn.net/v/t1.6435-9/48405980_2032409396796340_7380643041792491520_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=dd63ad&_nc_ohc=pTD5vTvYStgAX-R0smF&_nc_ht=scontent.fuab1-1.fna&oh=00_AfDY_Ai1Ku4xls_yKDqheBWt86icNbX31WnGeQJ_g2PW7g&oe=65A277D3",
          //   ),
          //   fit: BoxFit.cover,
          // ),
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Tuğba Gelin'in Evi"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(),
                  ),
                );
              },
              icon: Icon(Icons.notifications),
            ),
          ],
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ControlItemsList(),
            ),
          ],
        ),
      ),
    );
  }
}
