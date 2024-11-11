import 'package:employee_app/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Fluttertoast.showToast(
    msg: 'Logout Success',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0
  );
  Navigator.of(context).pop();
  Navigator.of(context).pushReplacementNamed('/login');
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Employee>> employeeListFuture;

  @override
  void initState() {
    super.initState();
    employeeListFuture = getEmployeeList();
  }

  Future<void> _refreshData() async {
    setState(() {
      employeeListFuture = getEmployeeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () async {
              // await logout(context);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        await logout(context);
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]
                )       
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _refreshData,
              child: Text("Refresh Data"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Employee>>(
                future: employeeListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No data found");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () { 
                              Navigator.of(context).pushNamed('/form', arguments: {'data': snapshot.data![index], 'status': 'Edit', 'refresh': _refreshData});
                            },
                            child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(12), 
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.deepPurple, width: 2), // Border around the container
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person,
                                      size: 75,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data![index].name}",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),  
                                    ),
                                    Text("NIK : ${snapshot.data![index].nik}"),
                                    Text("Email : ${snapshot.data![index].email}"),
                                    Text("Alamat : ${snapshot.data![index].alamat}"),
                                    Text("Telepon : ${snapshot.data![index].phone}"),
                                  ],
                                )                              
                              ],
                            ),
                          )
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/form', arguments: {'data': null, 'status': 'Add', 'refresh': _refreshData});
        },
        child: Icon(Icons.add),
        tooltip: 'Add Employee',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
    );
  }
}