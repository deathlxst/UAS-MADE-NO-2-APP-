import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TemperaturePage extends StatefulWidget {
  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  late DatabaseReference _temperatureRef;
  double temperature = 0;

  @override
  void initState() {
    super.initState();
    _temperatureRef = FirebaseDatabase.instance
        .reference()
        .child('data')
        .child('temperature');
    _temperatureRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          temperature = double.parse(snapshot.value.toString());
          print('Retrieved temperature: $temperature');
        });
      }
    });
  }

  @override
  void dispose() {
    _temperatureRef.onDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Temperature:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${temperature.toStringAsFixed(2)}°C',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
