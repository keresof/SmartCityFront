import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smart_city_app/providers/auth_provider.dart';
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
  List<String> uploadedMediaUrls = [];
  bool _isLoading = false;

  List<String> categories = [
    'Yol Sorunu',
    'Çöp Sorunu',
    'Trafiğe İlişkin Sorun',
    'Su/Lağım Sorunu',
    'Halk Sağlığı Sorunu(Salgın, Haşere, vb.)',
    'Diğer',
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

  Future<void> _uploadPhotos(
      String reportId, ReportProvider reportProvider) async {
    for (var image in images) {
      try {
        final url = await reportProvider.uploadFile(reportId, File(image.path));
        uploadedMediaUrls.add(url);
      } catch (e) {
        print('Error uploading file: $e');
        // Handle upload failure
      }
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('report_preview'.tr()),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${'title'.tr()}: ${titleController.text}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('${'category'.tr()}: $selectedCategory',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('${'description'.tr()}: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(descriptionController.text),
                SizedBox(height: 8),
                Text('${'location'.tr()}: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedAddress ?? 'selection_not_made'.tr()),
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
                Text('Images: ${images.length}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('cancel').tr(),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('submit_report').tr(),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context)
                    .unfocus(); // Unfocus here before submitting
                _submitReport();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitReport() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory == null ||
        selectedLocation == null ||
        selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('all_fields_required').tr()),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('login_to_submit_report').tr()),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final report = Report(
        title: titleController.text,
        description: descriptionController.text,
        location: [selectedAddress!],
        status: categories.indexOf(selectedCategory!),
        mediaUrls: [], // We'll upload files after creating the report
        coordinates: [selectedLocation!.latitude, selectedLocation!.longitude],
        userId: authProvider.user!.id,
      );

      final reportProvider =
          Provider.of<ReportProvider>(context, listen: false);
      final newReportId = await reportProvider.createReport(report);

      // Upload photos after creating the report
      await _uploadPhotos(newReportId, reportProvider);

      // Update the report with the new media URLs
      final updatedReport = Report(
        id: newReportId,
        title: report.title,
        description: report.description,
        location: report.location,
        status: report.status,
        mediaUrls: uploadedMediaUrls,
        coordinates: report.coordinates,
        userId: report.userId,
      );
      await reportProvider.updateReport(newReportId, updatedReport);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('report_submitted').tr()),
      );

      if (mounted) {
        context.go('/profile');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'error_submitting_report'.tr()}: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text('submit_report').tr(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('login_to_submit_report').tr(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: Text('login').tr(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('submit_report').tr(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'title'.tr()),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(labelText: 'category'.tr()),
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
                    decoration: InputDecoration(labelText: 'description'.tr()),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _selectLocation,
                    child: Text(selectedLocation != null
                        ? 'change_location'.tr()
                        : 'choose_location'.tr()),
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
                        label: Text('take_photo'.tr()),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(Icons.photo_library),
                        label: Text('choose_photo'.tr()),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  images.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                      : Text('photo_not_uploaded'.tr(),
                          textAlign: TextAlign.center),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _showPreviewDialog,
                    child: Text('preview').tr(),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
