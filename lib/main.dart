//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LEDControlApp());
}

class LEDControlApp extends StatelessWidget {
  const LEDControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    //DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

    return MaterialApp(
      title: 'Gestion des LED',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/ajouter_itineraire': (context) => const AjouterItineraireScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des LED'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: const Text(
                'Ajouter un itinéraire',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/ajouter_itineraire');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('M1'),
              onPressed: () {
                allumerLED('M1');
              },
            ),
            ElevatedButton(
              child: const Text('M2'),
              onPressed: () {
                allumerLED('M2');
              },
            ),
            ElevatedButton(
              child: const Text('M3'),
              onPressed: () {
                allumerLED('M3');
              },
            ),
            ElevatedButton(
              child: const Text('M4'),
              onPressed: () {
                allumerLED('M4');
              },
            ),
            ElevatedButton(
              child: const Text('M5'),
              onPressed: () {
                allumerLED('M5');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Allumer/Éteindre'),
              onPressed: () {
                allumerEteindreLED();
              },
            ),
          ],
        ),
      ),
    );
  }

  void allumerLED(String motif) {
    // Fonction pour allumer les LED en fonction du motif sélectionné
    print('Allumer les LED avec le motif $motif');
  }

  void allumerEteindreLED() {
    // Fonction pour allumer ou éteindre les LED
    print('Allumer/éteindre les LED');
  }
}

class AjouterItineraireScreen extends StatelessWidget {
  const AjouterItineraireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un itinerant'),
      ),
      body: const Center(
        child: Text('Écran Ajouter un itinéraire'),
      ),
    );
  }
}
