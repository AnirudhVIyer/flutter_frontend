import 'package:flutter/material.dart';
import 'package:flutter_frontend/home_screen.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'upload_photo_screen.dart';
import 'photo_list_screen.dart';
import 'report_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BDR App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(username:'user'),
        '/upload_photo': (context) => UploadPhotoScreen(),
        '/photo_list': (context) => PhotoListScreen(),
        '/report': (context) => ReportScreen(),
      },
    );
  }
}

