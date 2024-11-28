import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

class RouteScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng stopLocation;

  const RouteScreen(
      {super.key, required this.startLocation, required this.stopLocation});

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> routePoints = [];
  double totalKMs = 0.0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _createMarkers();
    _drawRoute();
    _calculateTotalDistance();
  }

  // Create markers for start and stop locations
  void _createMarkers() {
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: widget.startLocation,
        infoWindow: const InfoWindow(title: 'Start Location'),
      ));

      _markers.add(Marker(
        markerId: const MarkerId('stop'),
        position: widget.stopLocation,
        infoWindow: const InfoWindow(title: 'Stop Location'),
      ));
    });
  }

  // Draw route between start and stop locations
  void _drawRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBReg3EPynGV_Rac-nsCg0fxiq1ADyjYJI', // Replace with your API key
      PointLatLng(
          widget.startLocation.latitude, widget.startLocation.longitude),
      PointLatLng(widget.stopLocation.latitude, widget.stopLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        routePoints.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          visible: true,
          points: routePoints,
          color: Colors.blue,
          width: 4,
        ));
        isLoading = false; // Route fetched, stop loading
      });

      // After the route is drawn, adjust the camera to fit the markers and route
      _adjustCameraToFitMarkers();
    } else {
      setState(() {
        errorMessage = 'Unable to fetch route';
        isLoading = false;
      });
    }
  }

  // Calculate total kilometers traveled
  void _calculateTotalDistance() {
    totalKMs = Geolocator.distanceBetween(
          widget.startLocation.latitude,
          widget.startLocation.longitude,
          widget.stopLocation.latitude,
          widget.stopLocation.longitude,
        ) /
        1000; // Convert to kilometers
  }

  // Adjust the camera to show both markers and route
  void _adjustCameraToFitMarkers() {
    if (_mapController != null) {
      // Create bounds that encompass both markers
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          routePoints
              .map((point) => point.latitude)
              .reduce((a, b) => a < b ? a : b),
          routePoints
              .map((point) => point.longitude)
              .reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          routePoints
              .map((point) => point.latitude)
              .reduce((a, b) => a > b ? a : b),
          routePoints
              .map((point) => point.longitude)
              .reduce((a, b) => a > b ? a : b),
        ),
      );

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
            bounds, 50), // 50 is padding for the camera
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Details"),
      ),
      body: Column(
        children: [
          // Display loading state while the route is being fetched
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: widget.startLocation,
                      zoom: 12.0,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                  ),
                ),
          // Error message if route couldn't be fetched
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          // Route information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                    'Start Location: (${widget.startLocation.latitude}, ${widget.startLocation.longitude})'),
                Text(
                    'Stop Location: (${widget.stopLocation.latitude}, ${widget.stopLocation.longitude})'),
                Text('Total Distance: ${totalKMs.toStringAsFixed(2)} KM'),
                // TODO: Calculate total duration based on start and stop time
                const Text(
                    'Total Duration: 30 mins'), // Placeholder for duration
              ],
            ),
          ),
        ],
      ),
    );
  }
}
