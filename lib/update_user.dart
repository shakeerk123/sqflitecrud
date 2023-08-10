import 'package:flutter/material.dart';
import 'databasehelper.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key, required this.userId});
  final int userId;

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  void fetchData() async {
    Map<String, dynamic>? data = await DatabaseHelper.getSingleData(
        widget.userId); //to assign the data to the text fields
    if (data != null) {
      nameController.text = data['name'];
      ageController.text = data['age'].toString();
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'name': nameController.text,
      'age': ageController.text,
    };

    int id = await DatabaseHelper.updateData(widget.userId, data);
    Navigator.pop(context, true); //used to refresh after updating the main page
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(hintText: 'Age'),
            ),
            ElevatedButton(
                onPressed: () {
                  _updateData(context);
                },
                child: const Text("Update User"))
          ],
        ),
      ),
    );
  }
}
