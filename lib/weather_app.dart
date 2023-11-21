import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';

import 'additional_info.dart';
import 'hourly_forecast_items.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late double temp = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      isLoading = true;
      String cityName = 'Muridke';
      final res = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPI'),
      );
      final data = jsonDecode(res.body);

      if (data["cod"] != '200') {
        throw 'error';
      }
      return (data);
      /*setState(() {
      temp = data['list'][0]['main']['temp'];
      temp = temp - 273.15;
      isLoading = false;
    });*/
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.runtimeType);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final currentTemp =
              ((data['list'][0]['main']['temp']) - 273.15).toInt();
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentWind = data['list'][0]['wind']['speed'];
          final currentHumidity = data['list'][0]['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C',
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Icon(
                                currentSky == "Clouds"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$currentSky',
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Weather Forcast Card
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hourly Forecast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final time =
                            DateTime.parse(data['list'][index + 1]['dt_txt']);

                        return HourlyForecastItems(
                          time: DateFormat.Hm().format(time).toString(),
                          temprature: ((data['list'][index + 1]['main']
                                      ['temp']) -
                                  273.15)
                              .toInt()
                              .toString(),
                          icon: data['list'][index + 1]['weather'][0]['main'] ==
                                      'Clouds' ||
                                  data['list'][index + 1]['weather'][0]
                                          ['main'] ==
                                      'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      }),
                ),
                //Additional Info
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Additional Info',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionaInfo(
                      icon: Icons.water_drop,
                      lable: 'Humidity',
                      value: '$currentHumidity',
                    ),
                    AdditionaInfo(
                      icon: Icons.air,
                      lable: 'Wind Speed',
                      value: '$currentWind',
                    ),
                    AdditionaInfo(
                      icon: Icons.beach_access,
                      lable: 'Pressure',
                      value: '$currentPressure',
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
