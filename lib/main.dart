import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
                updateMotifValue('M1');
              },
            ),
            ElevatedButton(
              child: const Text('M2'),
              onPressed: () {
                updateMotifValue('M2');
              },
            ),
            ElevatedButton(
              child: const Text('M3'),
              onPressed: () {
                updateMotifValue('M3');
              },
            ),
            ElevatedButton(
              child: const Text('M4'),
              onPressed: () {
                updateMotifValue('M4');
              },
            ),
            ElevatedButton(
              child: const Text('M5'),
              onPressed: () {
                updateMotifValue('M5');
              },
            ),
            const SizedBox(height: 20),

            Padding(

              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text('Allumer'),
                    onPressed: () {
                      allumerEteindreLED('ON');
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Éteindre'),
                    onPressed: () {
                      allumerEteindreLED('OFF');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

void updateMotifValue(String motif) {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('LED_MOTIF');
  databaseReference.set(motif).then((value) {
    print('Valeur mise à jour avec succès');
  }).catchError((error) {
    print('Erreur lors de la mise à jour de la valeur : $error');
  });
}

void allumerEteindreLED(String motif) {
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('LED_STATUS');
  databaseReference.set(motif).then((value) {
    print('Valeur mise à jour avec succès');
  }).catchError((error) {
    print('Erreur lors de la mise à jour de la valeur : $error');
  });
}

