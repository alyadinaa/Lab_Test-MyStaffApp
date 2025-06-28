import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'list_staff_page.dart';
import 'home_page.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final ageController = TextEditingController();

  void submitStaff() async {
  if (_formKey.currentState!.validate()) {
    final name = nameController.text.trim();
    final id = idController.text.trim();
    final age = int.tryParse(ageController.text.trim());

    if (age == null || age < 18 || age > 55) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Age must be between 18 and 55')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('staff').add({
      'name': name,
      'id': id,
      'age': age,
    });

    // ✅ Show success dialog
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Added successfully'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ListStaffPage()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/MyStaff.png', width: 120),
                  const SizedBox(height: 12),
                  const Text(
                    'Add Staff',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
                        return 'Only letters and spaces allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ID
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'ID is required';
                      } else if (value.trim().length != 6) {
                        return 'ID must be exactly 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Age
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Age is required';
                      }
                      final age = int.tryParse(value.trim());
                      if (age == null || age < 18 || age > 55) {
                        return 'Age must be between 18 and 55';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: submitStaff,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAE4DFF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
