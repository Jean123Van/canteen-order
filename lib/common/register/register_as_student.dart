import 'dart:convert';
import 'dart:io';

import 'package:asbool/asbool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class RegisterAsStudent extends StatefulWidget {
  const RegisterAsStudent({super.key});

  @override
  State<RegisterAsStudent> createState() => _RegisterAsStudentState();
}

class _RegisterAsStudentState extends State<RegisterAsStudent> {
  String? firstName;
  String? middleName;
  String? lastName;
  String? password;
  String? studentNumber;
  XFile? image;
  bool isFirstNameFilled = true;
  bool isMiddleNameFilled = true;
  bool isLastNameFilled = true;
  bool isStudentNumberFilled = true;
  bool isPasswordFilled = true;
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          elevation: 10,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      labelText: 'First Name',
                      errorText:
                          isFirstNameFilled ? null : "This field is required"),
                  onChanged: (value) {
                    firstName = value;
                  },
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      labelText: 'Middle Name',
                      errorText:
                          isMiddleNameFilled ? null : "This field is required"),
                  onChanged: (value) {
                    middleName = value;
                  },
                ),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      errorText:
                          isLastNameFilled ? null : "This field is required"),
                  onChanged: ((value) {
                    lastName = value;
                  }),
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Student Number',
                      errorText: isStudentNumberFilled
                          ? null
                          : "This field is required"),
                  onChanged: (value) {
                    studentNumber = value;
                  },
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      errorText:
                          isPasswordFilled ? null : "This field is required"),
                  onChanged: (value) {
                    password = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: (() async {
                        image = await ImagePicker()
                            .pickImage(source: ImageSource.camera);
                        setState(() {});
                      }),
                      child: Text('Upload ID'),
                    ),
                    image == null
                        ? Icon(
                            Icons.close,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.check_box,
                            color: Colors.green,
                          ),
                  ],
                ),
                isLoading != null
                    ? isLoading!
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 147, 236, 150),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.all(10),
                            child: Text("Registration Success!"),
                          )
                    : ElevatedButton(
                        onPressed: () async {
                          if (asBool(firstName) &&
                              asBool(middleName) &&
                              asBool(lastName) &&
                              asBool(studentNumber) &&
                              asBool(password) &&
                              asBool(image)) {
                            isLoading = true;
                            setState(() {});
                            String name = firstName! +
                                ' ' +
                                middleName! +
                                ' ' +
                                lastName!;

                            var body = jsonEncode({
                              "name": name,
                              "studentNo": studentNumber,
                              "password": password,
                              'pic': jsonEncode(
                                  await File(image!.path).readAsBytes()),
                              'type': 'Student'
                            });
                            var result = await http.post(
                                Uri.parse('${dotenv.env["API_URL"]}/register'),
                                headers: {"Content-Type": "application/json"},
                                body: body);

                            if (result.statusCode == 200) {
                              isLoading = false;
                              setState(() {});
                            }
                          }

                          if (!asBool(firstName)) {
                            isFirstNameFilled = false;
                          }

                          if (!asBool(middleName)) {
                            isMiddleNameFilled = false;
                          }

                          if (!asBool(lastName)) {
                            isLastNameFilled = false;
                          }

                          if (!asBool(studentNumber)) {
                            isStudentNumberFilled = false;
                          }

                          if (!asBool(password)) {
                            isPasswordFilled = false;
                          }

                          if (asBool(firstName)) {
                            isFirstNameFilled = true;
                          }

                          if (asBool(middleName)) {
                            isMiddleNameFilled = true;
                          }

                          if (asBool(lastName)) {
                            isLastNameFilled = true;
                          }

                          if (asBool(studentNumber)) {
                            isStudentNumberFilled = true;
                          }

                          if (asBool(password)) {
                            isPasswordFilled = true;
                          }

                          setState(() {});
                        },
                        child: Text('Register'))
              ],
            ),
          )),
    );
  }
}
