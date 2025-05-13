import 'package:flutter/material.dart';
import 'package:crown_software_training_task/screens/login_screen.dart';
import 'package:crown_software_training_task/screens/admission_list.dart';
import 'package:crown_software_training_task/services/api_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: ApiService.isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data == true) {
            return const AdmissionListScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
