import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../repository/location_repository.dart';
import '../utils/google_maps_utils.dart';
import 'package:lab3/service/location_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      final location = await LocationService().getCurrentLocation();
      setState(() {
        userLocation = LatLng(location.latitude, location.longitude);
      });
    } else {
      print("Permission denied");
      // Handle denied or restricted permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Map',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(42.004517911284644, 21.408763749069088),
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  LocationRepository().finki.latitude,
                  LocationRepository().finki.longitude,
                ),
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    _showAlertDialog(
                        "FINKI",
                        LocationRepository().finki.latitude,
                        LocationRepository().finki.longitude);
                  },
                  child: const Icon(Icons.location_on),
                ),
              ),
              Marker(
                point: LatLng(
                  LocationRepository().tmf.latitude,
                  LocationRepository().tmf.longitude,
                ),
                width: 100,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    _showAlertDialog(
                        "TMF",
                        LocationRepository().tmf.latitude,
                        LocationRepository().tmf.longitude);
                  },
                  child: const Icon(Icons.location_on),
                ),
              ),
              if (userLocation != null)
                Marker(
                  point: userLocation!,
                  width: 100,
                  height: 100,
                  child: GestureDetector(
                    onTap: () {
                      _showAlertDialog(
                          "USER",
                          userLocation!.latitude,
                          userLocation!.longitude);
                    },
                    child: const Icon(Icons.location_on),
                  ),
                ),
            ],
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(
      String markerId, double latitude, double longitude) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open $markerId in Google Maps'),
          content: const Text('Do you want to open on Google Maps?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                MapUtils.openGoogleMaps(latitude, longitude);
                Navigator.of(context).pop();
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }
}
