import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_pop_scope.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  List<XFile> images = [];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        images.add(pickedImage);
      });
    }
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
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
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
                    // Implement submit logic
                    print('Submitting report...');
                    print('Description: ${descriptionController.text}');
                    print('Number of images: ${images.length}');
                    // TODO: Add your submission logic here
                    context.go('/home'); // Navigate back to home after submission
                  },
                  child: Text('Submit Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}