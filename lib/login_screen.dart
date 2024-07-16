import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

Future<void> _login() async {
    try {
      final response = await apiService.login(_emailController.text, _passwordController.text);
      print('Response: $response');  // Debug statement

      if (response.containsKey('access')) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['access']);
        await prefs.setString('username', response['user']['username']);
        print(prefs);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(username: response['user']['username']),
          ),
        );
      } else {
        setState(() {
          _message = 'Login failed: ${response['error']}';
        });
      }
    } catch (error) {
      print('Login error: $error');  // Debug statement
      setState(() {
        _message = 'Login failed: $error';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
