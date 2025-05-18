import 'package:crown_software_training_task/screens/admission_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/admission_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crown_software_training_task/models/post_model.dart';
import 'package:crown_software_training_task/models/photo_model.dart';
import 'package:crown_software_training_task/models/todo_model.dart';

class ApiService {
  static const String baseUrl = "https://glexas.com/hostel_data/API/test/";

  static const String admissionsUrl = "${baseUrl}new_admission_crud.php";
  static const String loginUrl = "${baseUrl}login.php";

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_token'); // or any login flag/key
  }
  // Fetch Admissions List
  static Future<List<Admission>> fetchAdmissions(int start, int limit) async {
    try {
      final response = await http.get(Uri.parse("$admissionsUrl?start=$start&limit=$limit"));
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        List list = jsonData['response'];
        return list.map((e) => Admission.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Fetch Error: $e');
      return [];
    }
  }

  // Add New Admission
  static Future<bool> addAdmission(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse(admissionsUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
      );
      debugPrint('POST Response: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('POST Error: $e');
      return false;
    }
  }

  // Update Admission
  static Future<bool> updateAdmission(Map<String, String> data) async {
    try {
      final response = await http.put(
        Uri.parse(admissionsUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      debugPrint('PUT Response: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('PUT Error: $e');
      return false;
    }
  }

  // Delete Admission
  static Future<bool> deleteAdmission(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(admissionsUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"registration_main_id": id}),
      );
      debugPrint('DELETE Response: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('DELETE Error: $e');
      return false;
    }
  }

  // Login API call
  static Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'status': false, 'message': 'Error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'status': false, 'message': 'Error: $e'};
    }
  }


  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
  Future<List<PhotoModel>> fetchPhotos({required int page}) async {
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/photos?_page=$page&_limit=20'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      // Replace thumbnail URLs with Picsum URLs
      final fixedData = data.map((json) {
        json['thumbnailUrl'] = 'https://picsum.photos/seed/${json['id']}/150/150';
        json['url'] = 'https://picsum.photos/seed/full_${json['id']}/600/400';
        return PhotoModel.fromJson(json);
      }).toList();

      return fixedData;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  Future<List<TodoModel>> fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => TodoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

}
