import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_city_app/models/report.dart';
import 'package:smart_city_app/models/user_reports.dart';
import '../widgets/custom_pop_scope.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  List<XFile> images = [];
  String? selectedCategory;
  LatLng? selectedLocation;
  String? selectedAddress;

  List<String> categories = [
    'Road Issue',
    'Garbage',
    'Streetlight Problem',
    'Water Supply',
    'Public Safety',
    'Other'
  ];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        images.add(pickedImage);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> _selectLocation() async {
    final LatLng? result = await context.push<LatLng>('/map-selection');
    if (result != null) {
      setState(() {
        selectedLocation = result;
      });
      _updateAddress();
    }
  }

  Future<void> _updateAddress() async {
    if (selectedLocation != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation!.latitude,
          selectedLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            selectedAddress = '${place.street} ${place.subThoroughfare}, '
                '${place.thoroughfare}, ${place.subLocality}, '
                '${place.locality}, ${place.postalCode}, ${place.country}';
          });
        }
      } catch (e) {
        print('Error getting address: $e');
        setState(() {
          selectedAddress = 'Unable to fetch address';
        });
      }
    }
  }

  void _showPreviewDialog() {
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
                Text('Category: $selectedCategory', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(descriptionController.text),
                SizedBox(height: 8),
                Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedAddress ?? 'Address not available'),
                SizedBox(height: 8),
                if (selectedLocation != null)
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: selectedLocation!,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('selected_location'),
                          position: selectedLocation!,
                        ),
                      },
                      liteModeEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                SizedBox(height: 8),
                Text('Number of Images: ${images.length}', style: TextStyle(fontWeight: FontWeight.bold)),
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
                _submitReport();
              },
            ),
          ],
        );
      },
    );
  }

void _submitReport() {
  if (selectedCategory == null || selectedLocation == null || selectedAddress == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all required fields')),
    );
    return;
  }

  final newReport = Report(
    id: DateTime.now().millisecondsSinceEpoch.toString(), // Use a proper ID in production
    category: selectedCategory!,
    description: descriptionController.text,
    location: selectedLocation!,
    address: selectedAddress!,
    imagePaths: images.map((image) => image.path).toList(),
    createdAt: DateTime.now(),
  );

  // In a real app, you'd send this to your backend
  // For now, we'll use a static list to store reports
  UserReports.addReport(newReport);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Report submitted successfully')),
  );
  context.go('/home');
}

  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      backPath: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Report a Problem'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _selectLocation,
                  child: Text(selectedLocation != null 
                    ? 'Change Location' 
                    : 'Select Location'),
                ),
                if (selectedAddress != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      selectedAddress!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Take Photo'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text('Choose from Gallery'),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                images.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Text('No images selected.', textAlign: TextAlign.center),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _showPreviewDialog,
                  child: Text('Preview Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}