import 'package:cu_smart_home/provider/commands.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlItemsList extends StatefulWidget {
  const ControlItemsList({super.key});

  @override
  State<ControlItemsList> createState() => _ControlItemsListState();
}

class _ControlItemsListState extends State<ControlItemsList> {
  bool mutfak = false;
  bool yatak = false;
  bool salon = true;
  bool cocuk = false;

  @override
  Widget build(BuildContext context) {
    Commands commands = Provider.of<Commands>(context, listen: false);

    return ListView(
      children: [
        SwitchListTile(
          title: Text("Çocuk Odası"),
          value: commands.cocuk,
          onChanged: (v) async {
            // commands.toggleChildRoom();
            setState(() {
              // cocuk = v;
              commands.cocuk = v;
            });
            if (v) {
              await commands.openLight();
            } else {
              await commands.closeLight();
            }
          },
        ),
        SwitchListTile(
          title: Text("Yatak odası"),
          value: yatak,
          onChanged: (v) {
            setState(() {
              yatak = v;
            });
          },
        ),
        SwitchListTile(
          title: Text("Salon"),
          value: salon,
          onChanged: (v) {
            setState(() {
              salon = v;
            });
          },
        ),
        SwitchListTile(
          // tileColor: mutfak ? Colors.redAccent : Colors.white,
          // thumbIcon: Icon(Icons.lightbulb),
          title: Text("Mutfak"),
          value: mutfak,
          onChanged: (v) async {
            if (v) {
              await commands.openLight();
              // mutfak = true;
            } else {
              await commands.closeLight();
              // mutfak = false;
            }
            setState(() {
              mutfak = v;
            });
          },
        ),
      ],
    );
  }
}
