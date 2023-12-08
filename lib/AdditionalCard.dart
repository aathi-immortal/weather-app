import 'package:flutter/material.dart';

class AdditionalCard extends StatefulWidget {
  final IconData iconData;
  final String climate;
  final String level;

  const AdditionalCard({
    super.key,
    required this.iconData,
    required this.climate,
    required this.level,
  });

  @override
  State<AdditionalCard> createState() => _AdditionalCardState();
}

class _AdditionalCardState extends State<AdditionalCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        children: [
          // Humidity
          // icon
          Icon(
            widget.iconData,
            size: 32,
          ),
          const SizedBox(
            height: 6,
          ),
          // icon
          Text(
            widget.climate,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 6,
          ),

          //extra information
          Text(
            widget.level,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
