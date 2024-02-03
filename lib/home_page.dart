import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> students = [];

  void logOut() {
    // Implement your logout logic here
    print('Logging out...');
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response =
      await http.get(Uri.parse('http://192.168.100.247/main/retrieve_users.php'));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result is Map && result.containsKey('status')) {
          if (result['status'] == 'success' && result.containsKey('students')) {
            setState(() {
              students = List<Map<String, dynamic>>.from(result['students']);
            });
          } else {
            // Handle API error
            print('API error: ${result['message']}');
          }
        } else {
          // Unexpected response format
          print('Unexpected response format: $result');
        }
      } else {
        // Handle HTTP error
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle general error
      print('Error: $e');

      // Check if it's a FormatException
      if (e is FormatException) {
        // Handle JSON decoding error
        print('JSON decoding error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logOut();
              // Navigate to login page or any other desired action
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Name: ${students[index]['name']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${students[index]['id']}'),
                  Text('Age: ${students[index]['age']}'),
                  Text('Grade: ${students[index]['grade']}'),
                  Text('Email: ${students[index]['email']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
