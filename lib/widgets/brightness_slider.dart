import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../provider/commands.dart';

class BrightnessSlider extends StatefulWidget {
  const BrightnessSlider({super.key});

  @override
  State<BrightnessSlider> createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  @override
  Widget build(BuildContext context) {
    Commands commands = Provider.of<Commands>(context, listen: false);
    return SfSlider(
      // enableIntervalSelection: false,
      stepSize: 25,
      // thumbIcon: Icon(Icons.lightbulb),
      activeColor: Colors.grey,
      inactiveColor: Colors.teal,
      edgeLabelPlacement: EdgeLabelPlacement.inside,
      min: 0.0,
      max: 100.0,
      value: context.watch<Commands>().ledBrightness,
      interval: 25,
      showTicks: true,
      showLabels: true,
      enableTooltip: true,
      minorTicksPerInterval: 0,
      onChangeEnd: (value) async {
        commands.setLedBrightness(value);

        await commands.setLedBrightnessFirebase(value);
        print("ended");
      },
      onChanged: (value) {
        commands.setLedBrightness(value);
        print("changed");
      },
    );
  }
}
