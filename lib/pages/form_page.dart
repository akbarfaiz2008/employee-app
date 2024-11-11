import 'dart:convert';

import 'package:employee_app/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> obj = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String status = obj['status'];
    final Employee? data = obj['data'];
    final VoidCallback refresh = obj['refresh'];

    final formKey = GlobalKey<FormState>();
    final nikKey = GlobalKey<FormFieldState>();
    final namaKey = GlobalKey<FormFieldState>();
    final emailKey = GlobalKey<FormFieldState>();
    final alamatKey = GlobalKey<FormFieldState>();
    final teleponKey = GlobalKey<FormFieldState>();

    final nikController = TextEditingController(text: data != null ? data.nik.toString() : '');
    final namaController = TextEditingController(text: data != null ? data.name : '');
    final emailController = TextEditingController(text: data != null ? data.email : '');
    final alamatController = TextEditingController(text: data != null ? data.alamat : '');
    final teleponController = TextEditingController(text: data != null ? data.phone : '');

    Future<void> save(context) async {
      if (formKey.currentState!.validate()) {
        BuildContext loading = context;
        loading.loaderOverlay.show();
        String nama = namaController.text;
        String alamat = alamatController.text;
        String telepon = teleponController.text;

        try {
          await http.post(
            Uri.parse('${dotenv.env['API_URL']}/api/update-employee/${data!.nik}'),
            headers:{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'name': nama,
              'alamat': alamat,
              'phone': telepon
            }),
          ).then((response) async {
            final obj = jsonDecode(response.body);

            if (response.statusCode == 200) {
              Fluttertoast.showToast(
                msg: 'Edit Success',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              loading.loaderOverlay.hide();
              refresh();
              Navigator.of(context).pop();
            } else {
              loading.loaderOverlay.hide();
              Fluttertoast.showToast(
                msg: obj['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
              );
            }
          });
        } catch (e) {
          loading.loaderOverlay.hide();
          Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      }
    }

    Future<void> add(context) async {
      if (formKey.currentState!.validate()) {
        BuildContext loading = context;
        loading.loaderOverlay.show();
        String nama = namaController.text;
        String alamat = alamatController.text;
        String telepon = teleponController.text;
        String email = emailController.text;
        String nik = nikController.text;

        try {
          await http.post(
            Uri.parse('${dotenv.env['API_URL']}/api/create-employee'),
            headers:{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'nik': nik,
              'name': nama,
              'email': email,
              'alamat': alamat,
              'phone': telepon
            }),
          ).then((response) async {
            final obj = jsonDecode(response.body);

            if (response.statusCode == 200) {
              Fluttertoast.showToast(
                msg: 'Add Success',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              loading.loaderOverlay.hide();
              refresh();
              Navigator.of(context).pop();
            } else {
              loading.loaderOverlay.hide();
              Fluttertoast.showToast(
                msg: obj['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
              );
            }
          });
        } catch (e) {
          loading.loaderOverlay.hide();
          Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
          );
        }
      }
    }

    Future<void> delete(context) async {
      BuildContext loading = context;
      try {
        loading.loaderOverlay.show();
        await http.post(
          Uri.parse('${dotenv.env['API_URL']}/api/delete-employee/${data!.nik}'),
        ).then((response) async {
          final obj = jsonDecode(response.body);

          if (response.statusCode == 200) {
            Fluttertoast.showToast(
              msg: 'Delete Success',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
            );
            loading.loaderOverlay.hide();
            refresh();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else {
            loading.loaderOverlay.hide();
            Fluttertoast.showToast(
              msg: obj['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
            );
          }
        });
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$status Employee'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  key: nikKey,
                  controller: nikController,
                  enabled: data != null ? false : true,
                  decoration: InputDecoration(labelText: 'NIK'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: namaKey,
                  controller: namaController,
                  decoration: InputDecoration(labelText: 'Nama'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: emailKey,
                  controller: emailController,
                  enabled: data != null ? false : true,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: alamatKey,
                  controller: alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  key: teleponKey,
                  controller: teleponController,
                  decoration: InputDecoration(labelText: 'Telepon'),
                ),
                Spacer(),
                data != null ? ElevatedButton(
                  onPressed: () {
                    save(context);
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50)
                  )
                ) : ElevatedButton(
                  onPressed: () {
                    add(context);
                  },
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50)
                  )
                ),
                SizedBox(height: 20),
                data != null ? ElevatedButton(
                  onPressed: () {
                    // delete(context);
                    showDialog(
                      context: context, 
                      builder: (context) => AlertDialog(
                        title: Text('Delete Employee'),
                        content: Text('Are you sure want to delete this employee?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              delete(context);
                            }, 
                            child: Text('Yes')
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, 
                            child: Text('No')
                          )
                        ]
                      )
                    );
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50)
                  )
                ) : SizedBox(height: 0)
              ],
            ),
          )
        )
      ),
    );
  }
}