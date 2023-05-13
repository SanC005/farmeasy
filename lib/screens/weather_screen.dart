import 'dart:collection';

import 'package:farmeasy/custom/days_cell.dart';
import 'package:farmeasy/custom/days_cell.dart';
import 'package:farmeasy/custom/hourly_cell.dart';
import 'package:farmeasy/fetchers/DataModels/fore_cast/hour.dart';
import 'package:farmeasy/fetchers/fetchers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../fetchers/DataModels/fore_cast/fore_cast.dart';
import '../models/helpers.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // final listOfHours = List.generate(
  //     10,
  //     (index) =>
  //         HourlyCell(time: "12:00", icon: Icon(Icons.sunny), temp: "24"));
  //
  // final listOfDays = List.generate(10,
  //     (index) => DaysCell(day: "Monday", icon: Icon(Icons.sunny), temp: "24"));

  late String x;

  @override
  void initState() {
    super.initState();
    x = "Bye"; //Originally it was hello #ChangesMadeByAbeed
  }

  String dayFromDateCalc(String currDate) {
    final splitted = currDate.split('-');

    Map<int, int> monthMap = {
      1: 3,
      2: 28,
      3: 14,
      4: 4,
      5: 9,
      6: 6,
      7: 11,
      8: 8,
      9: 5,
      10: 10,
      11: 7,
      12: 12,
    };

    Map<int, String> dayMap = {
      0: "Sunday",
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday"
    };

    List<int> everyDay = splitted.map(int.parse).toList();
    int yearEnd = int.parse((everyDay[0] / 100).toString().split('.')[1]);
    int month = everyDay[1];
    int day = everyDay[2];
    int centCode = 2;
    int a = yearEnd ~/ 12;
    int b = yearEnd % 12;
    int c = b ~/ 4;

    int ans = (a + b + c + centCode) % 7;

    int absVal = (monthMap[month]! - day).abs();
    ans = (ans + absVal) % 7;

    return dayMap[ans] ?? 'na';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataSources.getForecast('Delhi', 7),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          ForeCast foreCast = snapshot.data;
          String forecastCondition =
              foreCast.current?.condition?.text.toString() ??
                  'assets/cloud.json';
          print(weatherAnimation['Sunny']);
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const Text(
                "Today Weather Forecast",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    height: 180,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on),
                                const SizedBox(width: 8),
                                Text(
                                  foreCast.location?.name ?? 'NA',
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            const Icon(Icons.share)
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Lottie.asset(
                                  weatherAnimation[forecastCondition]!,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${foreCast.current!.tempC.toString()} °C' ??
                                        'NA',
                                    style: const TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    foreCast.current?.condition?.text ?? 'NA',
                                    style: const TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ])
                      ],
                    ),
                  )
                ],
              ),
              // const WeatherCard(),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                height: 160,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dataCell(
                            context,
                            const Icon(Icons.thermostat),
                            'Atm Pressure',
                            foreCast.current!.pressureMb.toString()),
                        dataCell(
                            context,
                            const Icon(Icons.wb_sunny_sharp),
                            ' SunRise',
                            foreCast.forecast![0].astro!.sunrise.toString() ??
                                'NA'),
                        dataCell(
                            context,
                            const Icon(Icons.wind_power),
                            'Wind Speed',
                            foreCast.current!.windKph.toString() ?? 'na')
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dataCell(
                            context,
                            const Icon(Icons.cloud),
                            ' Rain',
                            foreCast.forecast?[0].day!.dailyChanceOfRain
                                    .toString() ??
                                'NA'),
                        dataCell(
                            context,
                            const Icon(Icons.sunny_snowing),
                            ' Sunset',
                            foreCast.forecast![0].astro?.sunset.toString() ??
                                'NA'),
                        dataCell(
                            context,
                            const Icon(Icons.water_drop),
                            ' Humidity',
                            foreCast.current?.humidity.toString() ?? 'NA')
                      ],
                    )
                  ],
                ),
              ),
              Column(children: [
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    //  suraj code from here
                    height: 120,
                    child: ListView.builder(
                      itemCount: foreCast.forecast?[0].hour?.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Hour hour = foreCast.forecast![0].hour![index];
                        String wIcon = hour.condition?.text ?? 'Rainy';

                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: HourlyCell(
                              icon: weatherIcon[wIcon] ??
                                  const Icon(Icons.cloudy_snowing),
                              temp: hour.tempC.toString(),
                              time: hour.time.toString(),
                            ));
                      },
                    )),
                Column(
                  children: [
                    const Text(
                      "10 Days Forecast",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),

                        //child:listOfDays[0]

                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: foreCast.forecast?.length ?? 10,
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final String date =
                                foreCast.forecast![index].date.toString();
                            String day = dayFromDateCalc(date);

                            final String temp = foreCast
                                    .forecast![index].day!.avgtempC
                                    .toString() ??
                                'NA';

                             String iconType = foreCast
                                .forecast![index].day!.condition!.text
                                .toString();

                            if(!weatherIcon.containsKey(iconType)){
                              iconType = "Rainy";
                            }

                            //List<String> iconTypes = ["Sunny","Partly cloudy","Cloudy","Clear"]

                            return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: DaysCell(
                                    day: day, icon: iconType, temp: temp));
                          },
                        ))
                  ],
                )
              ])
            ],
          );
        }

        if (snapshot.hasError) {
          return const Placeholder();
        } else {
          return const SizedBox(
              width: 200, height: 200, child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget dataCell(BuildContext context, Icon icon, String name, String data) {
    return



        Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [icon, Text(name)],
        ),
        Text(data)
      ],
    );
  }
}
