import 'dart:convert';
import 'dart:math';

import 'package:asbool/asbool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class RegisterAsStore extends StatefulWidget {
  const RegisterAsStore({super.key});

  @override
  State<RegisterAsStore> createState() => _RegisterAsStoreState();
}

class _RegisterAsStoreState extends State<RegisterAsStore> {
  String? storeName;
  String? password;
  XFile? image;
  bool isNameFilled = true;
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
                  decoration: InputDecoration(
                      labelText: "Store Name",
                      errorText:
                          isNameFilled ? null : "This field is required"),
                  onChanged: (value) {
                    storeName = value;
                  },
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
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
                        onPressed: (() async {
                          if (asBool(storeName) &&
                              asBool(password) &&
                              asBool(image)) {
                            isLoading = true;
                            setState(() {});
                            var result = await http.post(
                                Uri.parse('${dotenv.env["API_URL"]}/register'),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  "name": storeName,
                                  "password": password,
                                  "type": "Store",
                                  "pic": jsonEncode(
                                      await File(image!.path).readAsBytes())
                                }));

                            if (result.statusCode == 200) {
                              isLoading = false;
                              setState(() {});
                            }
                          }

                          if (!asBool(storeName)) {
                            isNameFilled = false;
                          }

                          if (!asBool(password)) {
                            isPasswordFilled = false;
                          }

                          if (asBool(storeName)) {
                            isNameFilled = true;
                          }

                          if (asBool(password)) {
                            isPasswordFilled = true;
                          }

                          setState(() {});
                        }),
                        child: Text('Register'))
              ],
            ),
          )),
    );
  }
}
