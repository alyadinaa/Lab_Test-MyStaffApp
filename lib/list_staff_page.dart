import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_staff_page.dart';

class ListStaffPage extends StatelessWidget {
  const ListStaffPage({super.key});

  void deleteStaff(String docId, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete staff information?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              FirebaseFirestore.instance.collection('staff').doc(docId).delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Staff deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void editStaffDialog(BuildContext context, DocumentSnapshot doc) {
    final nameController = TextEditingController(text: doc['name']);
    final idController = TextEditingController(text: doc['id']);
    final ageController = TextEditingController(text: doc['age'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Staff'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: idController, decoration: const InputDecoration(labelText: 'ID')),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('staff').doc(doc.id).update({
                'name': nameController.text.trim(),
                'id': idController.text.trim(),
                'age': int.tryParse(ageController.text.trim()) ?? doc['age'],
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Staff updated')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffRef = FirebaseFirestore.instance.collection('staff');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AddStaffPage()),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/MyStaff.png', height: 80),
            const SizedBox(height: 10),
            const Text(
              'Staff List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: staffRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final docs = snapshot.data!.docs;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(Colors.black12),
                      columns: const [
                        DataColumn(label: Text('No')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Age')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: List<DataRow>.generate(docs.length, (index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return DataRow(cells: [
                          DataCell(Text('${index + 1}.')),
                          DataCell(Text(data['name'])),
                          DataCell(Text(data['id'])),
                          DataCell(Text(data['age'].toString())),
                          DataCell(Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => editStaffDialog(context, doc),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: const Icon(Icons.edit, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => deleteStaff(doc.id, context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.all(8),
                                ),
                                child: const Icon(Icons.delete, color: Colors.white, size: 18),
                              ),
                            ],
                          )),
                        ]);
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AddStaffPage()),
          );
        },
        backgroundColor: const Color(0xFFAE4DFF),
        icon: const Icon(Icons.person_add),
        label: const Text(
          'Add Staff',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
