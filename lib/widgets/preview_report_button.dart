import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PreviewReportButton extends StatelessWidget {
  final String category;
  final String description;
  final LatLng? location;
  final String? address;
  final List<String> imagePaths;
  final VoidCallback onSubmit;

  const PreviewReportButton({
    Key? key,
    required this.category,
    required this.description,
    required this.location,
    required this.address,
    required this.imagePaths,
    required this.onSubmit,
  }) : super(key: key);

  void _showPreviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Preview Report'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Category: $category', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(description),
                SizedBox(height: 8),
                Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(address ?? 'Address not available'),
                SizedBox(height: 8),
                if (location != null)
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: location!,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('selected_location'),
                          position: location!,
                        ),
                      },
                      liteModeEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                SizedBox(height: 8),
                Text('Images:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                imagePaths.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imagePaths.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(
                                File(imagePaths[index]),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )
                    : Text('No images selected'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                onSubmit();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showPreviewDialog(context),
      child: Text('Preview Report'),
    );
  }
}