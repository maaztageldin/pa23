import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(LEDControlApp());

class LEDControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LED Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LEDControlPage(),
    );
  }
}

class LEDControlPage extends StatefulWidget {
  @override
  _LEDControlPageState createState() => _LEDControlPageState();
}

class _LEDControlPageState extends State<LEDControlPage> {
  bool _isLEDOn = false;

  void _toggleLED() async {
    const url = 'http://adresse_de_votre_esp8266/on'; // Remplacez par l'URL réelle de votre ESP8266
    final response = await http.get(url as Uri);

    if (response.statusCode == 200) {
      setState(() {
        _isLEDOn = !_isLEDOn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LED Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isLEDOn ? 'LED Allumée' : 'LED Éteinte',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _toggleLED,
              child: Text(_isLEDOn ? 'Éteindre' : 'Allumer'),
            ),
          ],
        ),
      ),
    );
  }
}
