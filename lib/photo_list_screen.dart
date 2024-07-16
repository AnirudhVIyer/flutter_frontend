import 'package:flutter/material.dart';
import 'api_service.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
  List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    try {
      final photoList = await apiService.getPhotos();
      setState(() {
        photos = photoList;
      });
    } catch (e) {
      print('Failed to load photos: $e');
    }
  }

  Future<void> _deletePhoto(int photoId) async {
    try {
      await apiService.deletePhoto(photoId);
      _loadPhotos();
    } catch (e) {
      print('Failed to delete photo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Photos'),
      ),
      body: photos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GridTile(
                    header: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        photo['description'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          backgroundColor: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    footer: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePhoto(photo['id']),
                    ),
                    child: Image.network(
                      photo['image_url'],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
