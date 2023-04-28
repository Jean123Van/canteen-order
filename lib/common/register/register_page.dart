import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Q extends StatefulWidget {
  const Q({super.key});

  @override
  State<Q> createState() => _QState();
}

class _QState extends State<Q> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Middle Name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Student Number'),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
              onPressed: () async {
                var image =
                    await ImagePicker().pickImage(source: ImageSource.camera);
              },
              child: Text('Upload ID')),
          ElevatedButton(
              onPressed: () async {
                print('asdasdsad');
                var body = jsonEncode({
                  "firstName": "jean van",
                  "middleName": "asas",
                  "lastName": "sasas",
                  "studentNo": "Asasas",
                  "password": "asasas"
                });
                var result = await http.post(
                    Uri.parse('${dotenv.env["API_URL"]}/register/student'),
                    headers: {"Content-Type": "application/json"},
                    body: body);
              },
              child: Text('Register'))
        ],
      ),
    );
  }
}
