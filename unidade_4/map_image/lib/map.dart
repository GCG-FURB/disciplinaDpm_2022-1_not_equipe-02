import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class ScreenArguments {
  final Uint8List image;

  ScreenArguments(this.image);
}

class _MapScreenState extends State<MapScreen> {
  late Uint8List image;
  GoogleMapController? _controller;
  Location currentLocation = Location();
  MapType _currentMapType = MapType.normal;

  final Set<Marker> _markers = {};
  void getLocation() async {
    currentLocation.onLocationChanged.listen((LocationData loc) {
      getData('latitude').then((latitude) => {
            getData('longitude').then((longitude) => {
                  setState(() {
                    _controller?.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(latitude as double, longitude as double),
                      zoom: 12.0,
                    )));

                    _markers.add(Marker(
                        markerId: const MarkerId('Home'),
                        position:
                            LatLng(latitude as double, longitude as double),
                        icon: BitmapDescriptor.fromBytes(image)));
                  })
                })
          });
    });
  }

  late BitmapDescriptor icon;

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    getBytesFromAsset(args.image).then((value) => {image = value});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(48.8561, 2.2930),
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  const SizedBox(height: 16.0),
                  FloatingActionButton(
                    child: const Icon(
                      Icons.location_searching,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      getLocation();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(Uint8List i) async {
    ui.Codec codec = await ui.instantiateImageCodec(i, targetWidth: 250);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<Object> getData(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? "notfound";
  }

  Future<Object> getImage(key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "notfound";
  }
}
