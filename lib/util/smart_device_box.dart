import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/commands.dart';

class SmartDeviceBox extends StatelessWidget {
  final String smartDeviceName;
  final String iconPath;
  final bool powerOn;
  final void Function(bool) onChanged;

  SmartDeviceBox({
    Key? key, // Use the 'Key' parameter directly
    required this.smartDeviceName,
    required this.iconPath,
    required this.powerOn,
    required this.onChanged,
  }) : super(key: key); // Use 'super(key: key)' here

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: powerOn ? Colors.grey[900] : Color.fromARGB(44, 164, 167, 189),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (smartDeviceName == "Smart Light" && powerOn)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    "%${context.watch<Commands>().ledBrightness.toInt().toString()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: GoogleFonts.abel().fontFamily,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // icon

                  Image.asset(
                    iconPath,
                    height: 65,
                    color: powerOn ? Colors.white : Colors.grey.shade700,
                  ),

                  // smart device name + switch
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            smartDeviceName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: powerOn ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: pi / 2,
                        child: CupertinoSwitch(
                          value: powerOn,
                          onChanged: onChanged,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
