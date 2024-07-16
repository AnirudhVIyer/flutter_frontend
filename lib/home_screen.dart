import 'package:flutter/material.dart';
import 'upload_photo_screen.dart';  // Import the screen for uploading photos
import 'photo_list_screen.dart';  // Import the screen for viewing photos
import 'report_screen.dart';  // Import the screen for viewing reports
import 'login_screen.dart';  // Import the login screen for logout functionality
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  HomeScreen({required this.username});

  void _logout(BuildContext context) async{
    // Navigate back to the login screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _navigateToUploadPhoto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPhotoScreen()),
    );
  }

  void _navigateToViewPhotos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoListScreen()),
    );
  }

  void _navigateToViewReports(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Welcome, $username!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToUploadPhoto(context),
              child: Text('Upload Photo'),
            ),
            SizedBox(height: 20),
            Text('Your Photos', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () => _navigateToViewPhotos(context),
              child: Text('View Photos'),
            ),
            SizedBox(height: 20),
            Text('View Report', style: TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () => _navigateToViewReports(context),
              child: Text('Reports'),
            ),
          ],
        ),
      ),
    );
  }
}
