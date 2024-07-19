import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../models/report.dart';
import '../providers/report_provider.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController titleController = TextEditingController();
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
                '${place.locality}';
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
              Text('Title: ${titleController.text}', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Category: $selectedCategory', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(descriptionController.text),
              SizedBox(height: 8),
              Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(selectedAddress ?? 'Not selected'),
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
              Text('Images: ${images.length}', style: TextStyle(fontWeight: FontWeight.bold)),
              if (images.isNotEmpty)
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.file(
                          File(images[index].path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
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
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory == null ||
        selectedLocation == null ||
        selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final report = Report(
      title: titleController.text,
      description: descriptionController.text,
      location: [selectedAddress!],
      status: categories.indexOf(selectedCategory!),
      mediaUrls: images.map((image) => image.path).toList(),
      coordinates: [selectedLocation!.latitude, selectedLocation!.longitude],
      userId: "3fa85f64-5717-4562-b3fc-2c963f66afa6", // Replace with actual user ID when authentication is implemented
    );

    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    reportProvider.createReport(report).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully')),
      );
      context.go('/home');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit report: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report a Problem'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 16.0),
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
                                onPressed: () {
                                  setState(() {
                                    images.removeAt(index);
                                  });
                                },
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
    );
  }
}