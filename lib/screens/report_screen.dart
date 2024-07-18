import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  List<XFile> images = [];
  String? selectedCategory;
  LatLng? selectedLocation;

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

  void _selectLocation() async {
    // This is a placeholder. You'll need to implement a proper map selection screen.
    final LatLng? result = await context.push<LatLng>('/map-selection');
    if (result != null) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  bool _validateForm() {
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a category')));
      return false;
    }
    if (descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a description')));
      return false;
    }
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a location')));
      return false;
    }
    return true;
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Preview Report'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Category: $selectedCategory'),
                Text('Description: ${descriptionController.text}'),
                Text('Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}'),
                Text('Images: ${images.length}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => context.pop(),
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                // TODO: Implement actual submission logic here
                context.pop();
                context.go('/home');
              },
            ),
          ],
        );
      },
    );
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
                    ? 'Location selected: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}' 
                    : 'Select Location'),
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
                          return Image.file(
                            File(images[index].path),
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Text('No images selected.', textAlign: TextAlign.center),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      _showPreviewDialog(){
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
              Text('${selectedLocation?.latitude.toStringAsFixed(6)}, ${selectedLocation?.longitude.toStringAsFixed(6)}'),
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
                        child: Image.file(File(images[index].path), width: 80, height: 80, fit: BoxFit.cover),
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
              // TODO: Implement actual submission logic here
              Navigator.of(context).pop();
              context.go('/home');
            },
          ),
        ],
      );
    },
  );
};
                    }
                  },
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