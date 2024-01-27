import 'package:cu_smart_home/models/notification_model.dart';
import 'package:cu_smart_home/provider/commands.dart';
import 'package:cu_smart_home/provider/notifications.dart';
import 'package:cu_smart_home/widgets/brightness_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FirebaseScreen extends StatefulWidget {
  const FirebaseScreen({super.key});

  @override
  State<FirebaseScreen> createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  SfRangeValues _values = SfRangeValues(40.0, 80.0);
  dynamic _value = 75;

  @override
  Widget build(BuildContext context) {
    Commands commands = Provider.of<Commands>(context, listen: false);
    NtProvider ntProvider = Provider.of<NtProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await ntProvider.addNotification(
                  "Su vanası çalıştı",
                  "image",
                  "urgent",
                  true,
                );
                // await ntProvider.getNotifications();
              },
              child: Text("Firebase Screen"),
            ),

            // ElevatedButton(
            //   child: Text("Open Bottom Sheet"),
            //   onPressed: () {
            //     showModalBottomSheet(
            //       context: context,
            //       builder: (context) {
            //         return Container(
            //           height: 200,
            //           width: double.infinity,
            //           child: Center(
            //             child: BrightnessSlider(),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            // buildSlider(),
          ],
        ),
      ),
    );
  }

  SfSlider buildSlider() {
    return SfSlider(
      // enableIntervalSelection: false,
      stepSize: 25,
      min: 0.0,
      max: 100.0,
      value: _value,
      interval: 25,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      minorTicksPerInterval: 0,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }
}
