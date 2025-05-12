import 'package:flutter/material.dart';
import 'package:crown_software_training_task/services/api_service.dart';
import 'package:crown_software_training_task/models/admission_model.dart';

// Adds first letter capitalization for field labels
extension StringCasingExtension on String {
  String capitalize() => isEmpty ? "" : "${this[0].toUpperCase()}${substring(1)}";
}

class AdmissionListScreen extends StatefulWidget {
  const AdmissionListScreen({super.key});

  @override
  State<AdmissionListScreen> createState() => _AdmissionListScreenState();
}

class _AdmissionListScreenState extends State<AdmissionListScreen> {
  List<Admission> _admissions = [];
  final ScrollController _controller = ScrollController();
  int _start = 0;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchMore();

    // Load more data on scroll
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _fetchMore();
      }
    });
  }

  Future<void> _fetchMore() async {
    setState(() => _isLoading = true);
    final newAdmissions = await ApiService.fetchAdmissions(_start, _limit);
    setState(() {
      _admissions.addAll(newAdmissions);
      _isLoading = false;
      _start += _limit;
      if (newAdmissions.length < _limit) _hasMore = false;
    });
  }

  void _showAddDialog() {
    final _formKey = GlobalKey<FormState>();
    final Map<String, String> data = {
      "user_code": "",
      "first_name": "",
      "middle_name": "",
      "last_name": "",
      "phone_number": "",
      "phone_country_code": "",
      "email": "",
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Admission"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: data.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: key.replaceAll('_', ' ').capitalize(),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) => data[key] = val,
                    validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                final success = await ApiService.addAdmission(data);
                if (success) {
                  _start = 0;
                  _admissions.clear();
                  _hasMore = true;
                  _fetchMore();
                }
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showEditDeleteDialog(Admission admission) {
    final _formKey = GlobalKey<FormState>();
    final Map<String, String> data = {
      "registration_main_id": admission.registrationMainId,
      "user_code": admission.userCode,
      "first_name": admission.firstName,
      "middle_name": admission.middleName,
      "last_name": admission.lastName,
      "phone_number": admission.phoneNumber,
      "phone_country_code": admission.phoneCountryCode,
      "email": admission.email,
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit/Delete Admission"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: data.entries.map((entry) {
                if (entry.key == "registration_main_id") return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: TextFormField(
                    initialValue: entry.value,
                    decoration: InputDecoration(
                      labelText: entry.key.replaceAll('_', ' ').capitalize(),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (val) => data[entry.key] = val,
                    validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ApiService.deleteAdmission(admission.registrationMainId);
              if (success) {
                _start = 0;
                _admissions.clear();
                _hasMore = true;
                _fetchMore();
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                final success = await ApiService.updateAdmission(data);
                if (success) {
                  _start = 0;
                  _admissions.clear();
                  _hasMore = true;
                  _fetchMore();
                }
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admission List"),
        backgroundColor: Colors.indigo,
      ),
      body: _admissions.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        controller: _controller,
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isPortrait ? 2 : 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 2,
        ),
        itemCount: _admissions.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _admissions.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final admission = _admissions[index];
          return GestureDetector(
            onTap: () => _showEditDeleteDialog(admission),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${admission.firstName} ${admission.lastName}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(admission.email, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      "${admission.phoneCountryCode} ${admission.phoneNumber}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
