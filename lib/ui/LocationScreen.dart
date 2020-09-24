import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  MapScreen({this.alamat, this.lat, this.long});

  final String alamat;
  final double lat, long;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

// 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: 14.0,
        ),
        markers: _markers,
      ),
    );
  }

  @override
  void initState() {
    _markers.add(
      Marker(
        markerId: MarkerId("${widget.lat},${widget.long}"),
        position: LatLng(widget.lat, widget.long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: 'Alamat : ${widget.alamat}'),
      ),
    );
    super.initState();
  }
}
