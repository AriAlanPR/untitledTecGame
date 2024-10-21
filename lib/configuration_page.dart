import 'package:flutter/material.dart';
import 'package:untitled_tec_game/utils/coolborders.dart';

class ConfigurationPage extends StatelessWidget {
  final String defaultName = "Guest";

  const ConfigurationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: CoolBorders(
          borderDesign: BorderDesign.all,
          radius: 40,
        ).getRadius,
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade800.withOpacity(1),
            Colors.grey.shade700,
            Colors.blueGrey.shade800,
            Colors.blueGrey.shade700.withOpacity(1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text("Configuration user is $defaultName"),
          ],
        ),
      ),
    );
  }
}