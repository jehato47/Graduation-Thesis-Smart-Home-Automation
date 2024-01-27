import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Commands extends ChangeNotifier {
  bool mutfak = false;
  bool yatak = false;
  bool salon = true;
  bool cocuk = false;
  Map<String, Object> values = {};
  Object values2 = {};

  double ledBrightness = 0.0;

  void setLedBrightness(double value) {
    ledBrightness = value;
    notifyListeners();
  }

  Future<void> setLedBrightnessFirebase(double value) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["led_brightness"] = value;
    await ref.update(values);
  }

  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["Smart Light", "lib/icons/light-bulb.png", false],
    ["Smart AC", "lib/icons/air-conditioner.png", false],
    ["Smart TV", "lib/icons/smart-tv.png", false],
    ["Smart Fan", "lib/icons/fan.png", false],
  ];
  void powerSwitchChanged(bool value, int index) {
    mySmartDevices[index][2] = value;
    notifyListeners();
  }

  Future<void> getInitialData() async {
    // Get data from interior lightning as json
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    DataSnapshot snapshot = await ref.get();
    values2 = snapshot.value as Object;

    // convert values2 Object  to map
    values = Map<String, Object>.from(values2 as Map);

    // print(values.entries);

    // values = Map<String, Object>.from(values2);
    // print(values2);

    values.entries.forEach((entry) {
      String key = entry.key;
      Object value = entry.value;

      if (key == "living_room") {
        mySmartDevices[0][2] = value == "open_state" ? true : false;
      } else if (key == "air_conditioner") {
        mySmartDevices[1][2] = value == "open_state" ? true : false;
      } else if (key == "tv") {
        mySmartDevices[2][2] = value == "open_state" ? true : false;
      } else if (key == "fan") {
        mySmartDevices[3][2] = value == "open_state" ? true : false;
      } else if (key == "led_brightness") {
        ledBrightness = double.parse(value.toString());
      }
    });
    // print(mySmartDevices);
  }

  Future<void> toogleLight(bool value) async {
    if (value) {
      await openLight();
    } else {
      await closeLight();
    }
  }

  Future<void> openLight() async {
    // mutfak = true;
    // notifyListeners();
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["living_room"] = "open_state";
    await ref.update(values);
  }

  Future<void> closeLight() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["living_room"] = "close_state";
    await ref.update(values);
    // await ref.set({"living_room": "close_state"});
  }

  Future<void> openAc() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["air_conditioner"] = "open_state";
    await ref.update(values);

    // await ref.set({"air_conditioner": "open_state"});
  }

  Future<void> closeAc() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["air_conditioner"] = "close_state";
    await ref.update(values);

    // await ref.set({"air_conditioner": "close_state"});
  }

  Future<void> toggleAc(bool value) async {
    if (value) {
      await openAc();
    } else {
      await closeAc();
    }
  }

  Future<void> openTv() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["tv"] = "open_state";
    await ref.update(values);

    // await ref.set({"tv": "open_state"});
  }

  Future<void> closeTv() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["tv"] = "close_state";
    await ref.update(values);

    // await ref.set({"tv": "close_state"});
  }

  Future<void> toogleTv(bool value) async {
    if (value) {
      await openTv();
    } else {
      await closeTv();
    }
  }

  Future<void> openFan() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["fan"] = "open_state";
    await ref.update(values);

    // await ref.set({"fan": "open_state"});
  }

  Future<void> closeFan() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("interiorLighting");
    values["fan"] = "close_state";
    await ref.update(values);

    // await ref.set({"fan": "close_state"});
  }

  Future<void> toogleFan(bool value) async {
    if (value) {
      await openFan();
    } else {
      await closeFan();
    }
  }
}
