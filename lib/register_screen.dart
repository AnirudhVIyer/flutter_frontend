import 'package:flutter/material.dart';
import 'api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService apiService = ApiService(baseUrl: 'http://127.0.0.1:8000');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _register() async {
    try {
      final response = await apiService.register(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
      );
      print('Response status: ${response.statusCode}');  // Debug statement
      print('Response body: ${response.body}');  // Debug statement
      if (response.statusCode == 201) {
        setState(() {
          _message = 'Registration successful!';
        });
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _message = 'Registration failed: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        _message = 'Registration failed: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}


