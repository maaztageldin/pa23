import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LEDControlApp());
}

class LEDControlApp extends StatelessWidget {
  const LEDControlApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
  const HomeScreen({Key? key});

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
              child: const Text('French flag'),
              onPressed: () {
                updateMotifValue('M1');
              },
            ),
            ElevatedButton(
              child: const Text('Italian flag'),
              onPressed: () {
                updateMotifValue('M2');
              },
            ),
            ElevatedButton(
              child: const Text('Turn left'),
              onPressed: () {
                updateMotifValue('M3');
              },
            ),
            ElevatedButton(
              child: const Text('Turn right'),
              onPressed: () {
                updateMotifValue('M4');
              },
            ),
            /*ElevatedButton(
              child: const Text('M5'),
              onPressed: () {
                updateMotifValue('M5');
              },
            ),*/
            /*const SizedBox(height: 20),
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
                  ),*/


          ],
        ),
      ),
    );
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
}

class Itineraire {
  final String depart;
  final String arrivee;
  String tempsTrajet;

  Itineraire({required this.depart, required this.arrivee, this.tempsTrajet = ''});
}

class AjouterItineraireScreen extends StatefulWidget {
  const AjouterItineraireScreen({Key? key}) : super(key: key);

  @override
  _AjouterItineraireScreenState createState() => _AjouterItineraireScreenState();
}

class _AjouterItineraireScreenState extends State<AjouterItineraireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _departController = TextEditingController();
  final _arriveeController = TextEditingController();
  String _tempsTrajet = '';
  Set<Marker> _markers = {};

  bool _isSelecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un itinéraire'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _departController,
                decoration: const InputDecoration(labelText: 'Destination de départ'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une destination de départ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _arriveeController,
                decoration: const InputDecoration(labelText: 'Destination d\'arrivée'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer une destination d\'arrivée';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _choisirPointDepartArriveeSurCarte();
                  }
                },
                child: const Text('Calculer votre trajet'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: _isSelecting ? _choisirPointDepartArriveeSurCarte : null,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(48.8480, 2.3954),
                      zoom: 12.0,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {},
                    onTap: (LatLng latLng) {
                      if (_isSelecting) {
                        _ajouterMarqueur(latLng);
                      }
                    },
                  ),
                ),
              ),
              if (_tempsTrajet.isNotEmpty)
                Text(
                  'Temps de trajet : $_tempsTrajet',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _ajouterMarqueur(LatLng latLng) {
    setState(() {
      if (_isSelecting) {
        // Ajoutez le marqueur de la destination de départ
        if (_departController.text.isEmpty) {
          _departController.text = '${latLng.latitude}, ${latLng.longitude}';
        }
        // Ajoutez le marqueur de la destination d'arrivée
        else if (_arriveeController.text.isEmpty) {
          _arriveeController.text = '${latLng.latitude}, ${latLng.longitude}';
          _isSelecting = false;
          _calculerTempsTrajet();
        }
      }
    });
  }

  void _choisirPointDepartArriveeSurCarte() {
    setState(() {
      _isSelecting = true;
      _departController.text = '';
      _arriveeController.text = '';
      _tempsTrajet = '';
      _markers.clear();
    });
  }

  void _calculerTempsTrajet() async {
    final String depart = _departController.text;
    final String arrivee = _arriveeController.text;

    const String apiKey = 'AIzaSyCucgqIYO2cEUX6Tqf_iUkCTJRpRK3zuDw';
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$depart&destination=$arrivee&mode=bicycling&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = jsonDecode(response.body);
      final duration = data['routes'][0]['legs'][0]['duration']['text'];
      setState(() {
        _tempsTrajet = duration;
      });
    } catch (error) {
      print('Erreur lors du calcul du temps de trajet : $error');
    }

    // Ajoutez le marqueur de la destination de départ
    _markers.add(
      Marker(
        markerId: const MarkerId('depart'),
        position: _getLatLngFromString(depart),
        infoWindow: InfoWindow(title: 'Départ', snippet: depart),
      ),
    );

    // Ajoutez le marqueur de la destination d'arrivée
    _markers.add(
      Marker(
        markerId: const MarkerId('arrivee'),
        position: _getLatLngFromString(arrivee),
        infoWindow: InfoWindow(title: 'Arrivée', snippet: arrivee),
      ),
    );
  }

  LatLng _getLatLngFromString(String latLngString) {
    final latLngParts = latLngString.split(',');
    final latitude = double.parse(latLngParts[0].trim());
    final longitude = double.parse(latLngParts[1].trim());
    return LatLng(latitude, longitude);
  }
}
