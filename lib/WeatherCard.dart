import 'package:flutter/material.dart';

class WeatherCard extends StatefulWidget {
  final String time;
  final IconData climateIcon;
  final double temperature;

  const WeatherCard(
      {super.key,
      required this.time,
      required this.climateIcon,
      required this.temperature});

  @override
  State<WeatherCard> createState() => _WeatherCardBuilder();
}

class _WeatherCardBuilder extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.only(
          top: 8,
          right: 28,
          left: 28,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // text

            Text(
              widget.time,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // icon
            Icon(
              widget.climateIcon,
              size: 30,
            ),
            const SizedBox(
              height: 10,
            ),

            //extra information
            Row(
              children: [
                // temperature icon
                const Icon(
                  Icons.thermostat_outlined,
                  size: 18,
                ),
                Text(
                  widget.temperature.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class WeatherCard extends Card {
//   WeatherCard({super.key})
//       : super(
//         );
// }
