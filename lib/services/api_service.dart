import 'package:crown_software_training_task/screens/admission_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/admission_model.dart';

class ApiService {
  static const String baseUrl = "https://glexas.com/hostel_data/API/test/";

  static const String admissionsUrl = "${baseUrl}new_admission_crud.php";
  static const String loginUrl = "${baseUrl}login.php";

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
}
