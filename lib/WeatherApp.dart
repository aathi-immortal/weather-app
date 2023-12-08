import 'dart:convert';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/AdditionalCard.dart';

import 'package:weatherapp/WeatherCard.dart';
import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  double temperature = 0;

  WeatherCard getWeatherCard(final data, int index) {
    String time = parseTime(data, index);
    IconData icon = getIcon(data["list"][index]["weather"][0]["main"]);
    double temperature = data["list"][index]["main"]["temp"];

    return WeatherCard(time: time, climateIcon: icon, temperature: temperature);
  }

  Future<Map<String, dynamic>> apiRequest() async {
    // pass the url in this function

    try {
      final result = await http.get(
        Uri.parse(
            "http://api.openweathermap.org/data/2.5/forecast?q=London,us&APPID=d297a2b87211ce8f15d4689cae596f30"),
      );

      final datas = jsonDecode(result.body);
      if (int.parse(datas["cod"]) != 200) {
        throw "connection error please try again";
      }
      return datas;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    apiRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // adding app bar
        appBar: AppBar(
          // adding text in the app bar
          title: const Text("Weather App"),
          // center the title it look nice
          centerTitle: true,
          // adding refrese action in the app bar
          // when we press it it will display refrese to do it add gestureDector
          actions: [
            // in gestureDetector we hardly need to give padding
            // GestureDetector(
            //   onTap: refreshButtonPressed,
            //   child: const Icon(
            //     Icons.refresh,
            //   ),
            // ),
            // in icon button
            // we have inbuild onpressed
            // padding
            // animation in it default
            IconButton(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: FutureBuilder(
          future: apiRequest(),
          builder: (context, snapshot) {
            // cheching for connectionState
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            // if connection state is 200 set the temperature
            //
            final data = snapshot.data!;
            // temperature
            double currentTemperature = data["list"][0]["main"]["temp"];
            String weather = data["list"][0]["weather"][0]["main"];
            String humidityLevel =
                data["list"][0]["main"]["humidity"].toString();
            String windSpeed = data["list"][0]["wind"]["speed"].toString();
            String pressureLevel =
                data["list"][0]["main"]["pressure"].toString();
            IconData weatherIconInMainCard = getIcon(weather);

            // print(sizeOfList.length);

            return Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // main card

                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      // backdrop filter hace the property ImageFilter using it we can blur the background
                      // clicpRret used to create a rectangular clip
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                // temperature in farenheat
                                Text(
                                  '$currentTemperature° F',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // cloud icon
                                Icon(
                                  weatherIconInMainCard,
                                  size: 38,
                                ),

                                // season text
                                Text(
                                  weather,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // weather forecast card

                  const Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: listOfWeatherForecast,
                  //   ),
                  // ),

                  SizedBox(
                    height: 125,
                    // lazzy builder build the widget when we scroll it
                    // untill required widgets are showen
                    // it increases the performance of the app

                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return getWeatherCard(data, index + 1);
                      },
                    ),
                  ),

                  // additional information

                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // additional card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalCard(
                        iconData: Icons.water_drop_rounded,
                        climate: "Humidity",
                        level: humidityLevel,
                      ),
                      AdditionalCard(
                        iconData: Icons.air,
                        climate: "Wind Speed",
                        level: windSpeed,
                      ),
                      AdditionalCard(
                        iconData: Icons.beach_access,
                        climate: "Pressure",
                        level: pressureLevel,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }

  IconData getIcon(String weather) {
    if (weather.compareTo("Clouds") == 0) {
      return Icons.cloud;
    } else if (weather.compareTo("Clear") == 0) {
      return Icons.wb_sunny_outlined;
    } else if (weather.compareTo("Rain") == 0) {
      return Icons.thunderstorm_rounded;
    }
    return Icons.close;
  }

  String parseTime(final data, final index) {
    final time = DateTime.parse(data["list"][index]["dt_txt"]);
    return DateFormat.j().format(time);
  }
}
