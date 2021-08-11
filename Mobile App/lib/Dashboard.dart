import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watery/DisplayWidget.dart';
import 'package:watery/Segoe.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Timer timer;
  final databaseRef = FirebaseDatabase.instance.reference();

  int temperature = 0, soilMoisture = 0, humidity = 0, waterLevel = 0;
  AlignmentGeometry beginPosition = Alignment.centerLeft;
  AlignmentGeometry endPosition = Alignment.centerRight;

  void printFirebase() {
    setState(() {
      databaseRef.once().then((DataSnapshot snapshot) {
        temperature = snapshot.value['Temperature'];
        soilMoisture = snapshot.value['SoilMoisture'];
        humidity = snapshot.value['Humidity'];
        waterLevel = snapshot.value['WaterLevel'].toInt();
        waterLevel = ((waterLevel / 20) * 100).toInt();

      });
    });
  }

  void setMotor(bool check) {
    String motorStatus = check ? "active" : "inactive";

    databaseRef.set({
      'MotorStatus': motorStatus,
      'Humidity': humidity,
      'SoilMoisture': soilMoisture,
      'Temperature': temperature,
      'WaterLevel': waterLevel,
    });
  }

  Widget defaultBtnWidget = Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        radius: 35.0,
        child: Icon(
          FontAwesomeIcons.powerOff,
          color: Colors.green,
          size: 32.0,
        ),
      ),
      Spacer(),
      Text(
        'Tap to water',
        style: TextStyle(fontFamily: Segoe.light, fontSize: 20.0, color: Color(0xff464646)),
      ),
      SizedBox(
        width: 20.0,
      ),
      Spacer(),
    ],
  );

  Widget buttonWidget = Row(
    children: [
      CircleAvatar(
        backgroundColor: Colors.white,
        radius: 35.0,
        child: Icon(
          FontAwesomeIcons.powerOff,
          color: Colors.green,
          size: 32.0,
        ),
      ),
      Spacer(),
      Text(
        'Tap to water',
        style: TextStyle(fontFamily: Segoe.light, fontSize: 20.0, color: Color(0xff464646)),
      ),
      SizedBox(
        width: 20.0,
      ),
      Spacer(),
    ],
  );

  bool watering = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => printFirebase());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  "assets/images/logo.png",
                  width: MediaQuery.of(context).size.width * 0.48,
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width * 0.62,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [const Color(0xFFB2C7E3), const Color(0xFFE9F2FE)],
                      begin: beginPosition,
                      end: endPosition,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.0),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (!watering) {
                          setMotor(true);
                          watering = !watering;

                          beginPosition = Alignment.centerRight;
                          endPosition = Alignment.centerLeft;

                          buttonWidget = Row(
                            children: [
                              Spacer(),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'Tap to stop',
                                style: TextStyle(fontFamily: Segoe.light, fontSize: 20.0, color: Color(0xff464646)),
                              ),
                              Spacer(),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35.0,
                                child: Icon(
                                  FontAwesomeIcons.powerOff,
                                  color: Colors.red,
                                  size: 32.0,
                                ),
                              ),
                            ],
                          );
                        } else {
                          setMotor(false);
                          beginPosition = Alignment.centerLeft;
                          endPosition = Alignment.centerRight;
                          watering = !watering;
                          buttonWidget = defaultBtnWidget;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buttonWidget,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DisplayWidget(
                      icon: "temperatureIcon.svg",
                      title: "Temperature",
                      value: temperature,
                      unit: "degree",
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    DisplayWidget(
                      icon: "moistureIcon.svg",
                      title: "Soil Moisture",
                      value: soilMoisture,
                      unit: "percentage",
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DisplayWidget(
                      icon: "humidityIcon.svg",
                      title: "Humidity",
                      value: humidity,
                      unit: "percentage",
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    DisplayWidget(
                      icon: "waterLevelIcon.svg",
                      title: "Water Level",
                      value: waterLevel,
                      unit: "percentage",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
