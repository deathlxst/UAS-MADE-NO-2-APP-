import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HumidityPage extends StatefulWidget {
  @override
  _HumidityPageState createState() => _HumidityPageState();
}

class _HumidityPageState extends State<HumidityPage> {
  late DatabaseReference _humidityRef;
  double humidity = 0;

  @override
  void initState() {
    super.initState();
    _humidityRef = FirebaseDatabase.instance
        .reference()
        
        .child('data')
        .child('humidity');
    _humidityRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          humidity = double.parse(snapshot.value.toString());
          print('Retrieved humidity: $humidity');
        });
      }
    });
  }

  @override
  void dispose() {
    _humidityRef.onDisconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Humidity Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Humidity:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${humidity.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}