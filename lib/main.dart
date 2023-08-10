import 'package:flutter/material.dart';
import 'package:sqflitecrud/databasehelper.dart';
import 'package:sqflitecrud/update_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  List<Map<String, dynamic>> dataList = [];

  void _saveData() async {
    final name = nameController.text;
    final age = int.tryParse(ageController.text) ?? 0;
    int insertId = await DatabaseHelper.insertUser(name, age);
   

    List<Map<String, dynamic>> updateData = await DatabaseHelper.getData();
    setState(() {
      dataList = updateData;
    });
    nameController.text = '';
    ageController.text = '';
  }

  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  void _fetchUsers() async {
    List<Map<String, dynamic>> userList = await DatabaseHelper.getData();
    setState(() {
      dataList = userList; //assigning using set state
    });
  }

  void _delete(int docId) async {
    int id = await DatabaseHelper.deleteData(docId);
    List<Map<String, dynamic>> updateData =
        await DatabaseHelper.getData(); //to get the latest data from the db
    setState(() {
      dataList = updateData;
    });
  }

  void fetchData() async {
    List<Map<String, dynamic>> fetchedData = await DatabaseHelper.getData();
    setState(() {
      dataList = fetchedData;
    });
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
        title: const Center(child: Text("SQFlite")),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Column(
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
                      onPressed: _saveData, child: const Text("Save User"))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(dataList[index]['name']),
                        subtitle: Text('Age : ${dataList[index]['age']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateUser(
                                          userId: dataList[index]['id']),
                                    ),
                                  ).then((result) {  //to register a callback function that will be executed when the Future completes
                                    if (result == true) {
                                      //refresh data on the current screen
                                      fetchData();
                                    }
                                  });
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  _delete(dataList[index]['id']);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
