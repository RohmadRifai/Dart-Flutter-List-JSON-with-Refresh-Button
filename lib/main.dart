import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Sensors'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = "https://smart-hyco.herokuapp.com/sensor";

  Future<List<Sensor>> sensors;

  @override
  void initState() {
    super.initState();
    sensors = _getSensor();
  }

  Future<List<Sensor>> _getSensor() async {
    var respone = await http.get(url);
    if (respone.statusCode == 200) {
      final items = json.decode(respone.body).cast<Map<String, dynamic>>();
      List<Sensor> listOfSensors = items.map<Sensor>((json) {
        return Sensor.fromJson(json);
      }).toList();
      return listOfSensors;
    } else {
      throw Exception('Failed to load internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                sensors = _getSensor();
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: sensors,
          builder:
              (BuildContext context, AsyncSnapshot<List<Sensor>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Suhu Udara: ${snapshot.data[index].data_air_temp}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Kelembapan: ${snapshot.data[index].data_humidity}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'pH: ${snapshot.data[index].data_ph}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'PPM: ${snapshot.data[index].data_ppm}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Suhu Air: ${snapshot.data[index].data_water_temp}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Sensor {
  final String data_air_temp;
  final String data_humidity;
  final String data_ph;
  final String data_ppm;
  final String data_water_temp;

  Sensor({
    this.data_air_temp,
    this.data_humidity,
    this.data_ph,
    this.data_ppm,
    this.data_water_temp,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      data_air_temp: json["data_air_temp"],
      data_humidity: json["data_humidity"],
      data_ph: json["data_ph"],
      data_ppm: json["data_ppm"],
      data_water_temp: json["data_water_temp"],
    );
  }
}
