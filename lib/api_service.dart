import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/api/token/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Login failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return {'error': 'Failed to login'};
      }
    } catch (error, stackTrace) {
      print('Login API call error: $error');
      print('Stack trace: $stackTrace');
      return {'error': 'An error occurred'};
    }
  }

  Future<http.Response> register(String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'phone': phone,
          'password1': password,  // Use password1 and password2 as expected by the form
          'password2': password,
        }),
      );
      return response;
    } catch (error, stackTrace) {
      print('Register API call error: $error');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }


  Future<List<dynamic>> getPhotos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/photos/'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['photos'];
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<void> uploadPhoto(String filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/photos/upload/'));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
      request.fields['description'] = 'Uploaded from Flutter';  // Add other fields if needed

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed with status: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');  // Print response body
      }
    } catch (error, stackTrace) {
      print('Upload photo API call error: $error');
      print('Stack trace: $stackTrace');
    }
  }

Future<void> uploadPhotoWeb(String fileName, String base64Image) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token == null) {
    throw Exception('No token found');
  }

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/photos/upload/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'image': 'data:image/jpeg;base64,$base64Image', // Make sure to use the correct format
        'description': 'Uploaded from Flutter',  // Add other fields if needed
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');  // Print response body
    }
  } catch (error, stackTrace) {
    print('Upload photo API call error: $error');
    print('Stack trace: $stackTrace');
  }
}
  Future<void> deletePhoto(int photoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/photos/delete/$photoId/'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete photo');
    }
  }
}
