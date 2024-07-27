import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class MapSelectionScreen extends StatefulWidget {
  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng _centerLocation = LatLng(0, 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('location_permission_denied'.tr());
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('location_permission_denied_forever'.tr());
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _centerLocation = newLocation;
      });

      _mapController
          ?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 15));
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('${'error_determining_location'.tr()}: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerLocation = position.target;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_location').tr(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _centerLocation,
              zoom: 15,
            ),
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          Center(
            child: Icon(Icons.location_pin, color: Colors.red, size: 50),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedButton(
                  child: Text('use_current_location').tr(),
                  onPressed: _getCurrentLocation,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  child: Text('confirm_location').tr(),
                  onPressed: () {
                    context.pop(_centerLocation);
                  },
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
