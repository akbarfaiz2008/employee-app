import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Employee {
  final int nik;
  final String name;
  final String email;
  final String alamat;
  final String phone;

  Employee(this.nik, this.name, this.email, this.alamat, this.phone);

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      json['nik'], 
      json['name'], 
      json['email'], 
      json['alamat'],
      json['phone']
    );
  }
}

Future<List<Employee>> getEmployeeList() async {
  try {
    final response = await http.get(Uri.parse('${dotenv.env['API_URL']}/api/list-employee'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((item) => Employee.fromJson(item)).toList();
    }

    return [];
  } catch (e) {
    return [];
  }
    
}