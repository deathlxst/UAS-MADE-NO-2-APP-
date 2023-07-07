import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'temperature.dart';
import 'humidity.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 late bool isDoorLocked = false;
 late DatabaseReference doorLockRef;

@override
void initState() {
    super.initState();
    doorLockRef = FirebaseDatabase.instance.reference().child('data').child('door_lock');
    doorLockRef.onValue.listen((event) {
      final doorLockValue = event.snapshot.value;
      setState(() {
        isDoorLocked = doorLockValue == 1;
      });
    });
  }
  void toggleDoorLock() {
    setState(() {
      isDoorLocked = !isDoorLocked;
          doorLockRef.set(isDoorLocked ? 1 : 0);
       print('toggleDoorLock: isDoorLocked = $isDoorLocked');

    });
  }

  @override
  Widget build(BuildContext context) {
   print('build: isDoorLocked = $isDoorLocked');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Sensor and Doorlock App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TemperaturePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.thermostat, size: 48),
              label: Text('Temperature', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HumidityPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(Icons.opacity, size: 48),
              label: Text('Humidity', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: toggleDoorLock,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                isDoorLocked ? Icons.lock : Icons.lock_open,
                size: 48,
              ),
              label: Text(
                isDoorLocked ? 'Locked' : 'Unlocked',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
