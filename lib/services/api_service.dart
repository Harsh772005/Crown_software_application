import 'package:crown_software_training_task/screens/admission_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/admission_model.dart';

class ApiService {
  static const String url = "https://glexas.com/hostel_data/API/test/new_admission_crud.php";

  static Future<List<Admission>> fetchAdmissions(int start, int limit) async {
    try {
      final response = await http.get(Uri.parse("$url?start=$start&limit=$limit"));
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

  static Future<bool> addAdmission(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
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

  static Future<bool> updateAdmission(Map<String, String> data) async {
    try {
      final response = await http.put(
        Uri.parse(url),
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


  static Future<bool> deleteAdmission(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
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

}