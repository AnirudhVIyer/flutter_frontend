import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'api_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadPhotoScreen extends StatefulWidget {
  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  String _message = '';

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedImage;
      });
    } catch (error) {
      print('Image picking error: $error');
      setState(() {
        _message = 'Image picking failed: $error';
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      setState(() {
        _message = 'No image selected';
      });
      return;
    }

    try {
      String? fileName = _image!.path.split('/').last;
      if (kIsWeb) {
        // Handle image upload for web
        final bytes = await _image!.readAsBytes();
        final base64Image = base64Encode(bytes);
        await apiService.uploadPhotoWeb(fileName, base64Image);
      } else {
        // Handle image upload for mobile
        await apiService.uploadPhoto(_image!.path);
      }
      setState(() {
        _message = 'Image uploaded successfully';
      });
    } catch (error) {
      print('Image upload error: $error');
      setState(() {
        _message = 'Image upload failed: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            _image != null
                ? kIsWeb
                    ? Image.network(
                        _image!.path,
                        width: 200,  // Restrict image width
                        height: 200,  // Restrict image height
                        fit: BoxFit.cover,  // Cover the box constraints
                      )
                    : Image.file(
                        File(_image!.path),
                        width: 200,  // Restrict image width
                        height: 200,  // Restrict image height
                        fit: BoxFit.cover,  // Cover the box constraints
                      )
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
