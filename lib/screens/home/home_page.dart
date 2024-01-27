import 'package:cu_smart_home/provider/notifications.dart';
import 'package:cu_smart_home/screens/notification/notification_screen.dart';

import '../../provider/commands.dart';
// import '../../widgets/alert_dialog.dart';
import '../../widgets/brightness_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../util/smart_device_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 15;
  double slideValue = 0.5;

  // list of smart devices

  // power button switched
  // void powerSwitchChanged(bool value, int index) {
  //   setState(() {
  //     mySmartDevices[index][2] = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Commands commands = Provider.of<Commands>(context, listen: false);
    NtProvider ntProvider = Provider.of<NtProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  // Image.asset(
                  //   'lib/icons/menu.png',
                  //   height: 45,
                  //   color: Colors.grey[800],
                  // ),

                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  ),
                  // account icon
                  FutureBuilder(
                      future: ntProvider.getNotifications(),
                      builder: (context, snapshot) {
                        return Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NotificationScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.notifications,
                                size: 45,
                                color: Colors.grey[800],
                              ),
                            ),
                            Positioned(
                              child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  context
                                      .watch<NtProvider>()
                                      .unReadCount
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),

            const SizedBox(height: 15),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home,",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Text(
                    'Jehat Armanç Deniz',
                    style: GoogleFonts.bebasNeue(fontSize: 30),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 25),

            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // grid
            Expanded(
              child: GridView.builder(
                itemCount: context.watch<Commands>().mySmartDevices.length,
                // physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      if (index == 0) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 200,
                              child: Column(
                                children: [
                                  Container(
                                    // Add a close button to the dialog
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Brightness Of Light ",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.lightbulb_outline,
                                          color: Colors.grey,
                                          // color: Colors.yellow,
                                        ),
                                        // Image.asset(
                                        //   "lib/icons/light-bulb.png",
                                        //   height: 30,
                                        //   color: false
                                        //       ? Colors.white
                                        //       : Colors.grey.shade700,
                                        // )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  BrightnessSlider(),
                                ],
                              ),
                            );
                          },
                        );

                        // showAdaptiveDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return SliderDialog();
                        //     });

                        //   showModalBottomSheet(
                        //       context: context,
                        //       builder: (context) => Text("123"));
                      }
                    },
                    child: Hero(
                      tag: index.toString(),
                      child: SmartDeviceBox(
                        smartDeviceName:
                            context.watch<Commands>().mySmartDevices[index][0],
                        iconPath:
                            context.watch<Commands>().mySmartDevices[index][1],
                        powerOn: context.watch<Commands>().mySmartDevices[index]
                            [2],
                        onChanged: (value) async {
                          if (index == 0) {
                            // open light
                            await commands.toogleLight(value);
                          } else if (index == 1) {
                            // open ac
                            await commands.toggleAc(value);
                          } else if (index == 2) {
                            // open tv
                            await commands.toogleTv(value);
                            // commands.toogleTv(value);
                          } else if (index == 3) {
                            // open fan
                            await commands.toogleFan(value);
                            // commands.toogleFan(value);
                          }

                          commands.powerSwitchChanged(value, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
