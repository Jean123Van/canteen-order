import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:asbool/asbool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  final userId;
  const AddProduct({super.key, this.userId});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  XFile? image;
  String? name;
  String? description;
  String? price;
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Material(
              elevation: 5,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                width: double.infinity,
                child: Column(
                  children: [
                    if (asBool(image))
                      FutureBuilder(
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Container(
                              child: Image.memory(snapshot.data!),
                              height: 300,
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                        future: File(image!.path).readAsBytes(),
                      ),
                    ElevatedButton(
                        onPressed: (() async {
                          image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {});
                        }),
                        child: Text('Upload Thumbnail')),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Name",
                          errorText:
                              asBool(name) ? null : "Name cannot be empty"),
                      onChanged: (value) {
                        name = value;
                        setState(() {});
                      },
                    ),
                    TextField(
                      maxLines: 10,
                      minLines: 1,
                      decoration: InputDecoration(
                          labelText: "Description", hintText: "Description"),
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          errorText:
                              asBool(price) ? null : "Price cannot be empty",
                          labelText: "Price",
                          hintText: "Price"),
                      onChanged: (value) {
                        price = value;
                        setState(() {});
                      },
                    ),
                    isLoading != null
                        ? (isLoading!
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                child:
                                    Text("Add Complete, Click to Add Another"),
                                onPressed: (() {
                                  isLoading = null;
                                  setState(() {});
                                }),
                              ))
                        : ElevatedButton(
                            onPressed: (asBool(name) && asBool(price))
                                ? (() async {
                                    isLoading = true;
                                    setState(() {});

                                    var result = await http.post(
                                        Uri.parse(
                                            '${dotenv.env["API_URL"]}/menu/submit'),
                                        headers: {
                                          "Content-Type": "application/json"
                                        },
                                        body: jsonEncode({
                                          'userId': widget.userId,
                                          "name": name,
                                          "description": asBool(description)
                                              ? description
                                              : null,
                                          "price": price,
                                          "pic": image != null
                                              ? jsonEncode(
                                                  await File(image!.path)
                                                      .readAsBytes())
                                              : null
                                        }));

                                    isLoading = false;
                                    setState(() {});
                                  })
                                : null,
                            child: Text('Submit'))
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
