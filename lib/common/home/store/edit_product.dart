import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:asbool/asbool.dart';
import 'package:pickerimagetest/common/home/store/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  String id;
  String? userId;
  final updateFn;
  EditProduct({super.key, required this.id, this.userId, this.updateFn});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var image;
  String? name;
  String? description;
  String? price;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    var result =
        await http.post(Uri.parse('${dotenv.env["API_URL"]}/menu/get/one'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'id': widget.id,
            }));

    image = jsonDecode(result.body)['pic'];
    name = jsonDecode(result.body)['name'];
    description = jsonDecode(result.body)['description'];
    price = jsonDecode(result.body)['price'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 10,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (asBool(image))
                  Container(
                    child: Image.memory(
                        Uint8List.fromList(jsonDecode(image).cast<int>())),
                    height: 300,
                  ),
                ElevatedButton(
                    onPressed: () async {
                      var imagePath = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      image =
                          jsonEncode(await File(imagePath!.path).readAsBytes());

                      setState(() {});
                    },
                    child: Text('Upload Thumbnail')),
                TextField(
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Name",
                      errorText: asBool(name) ? null : "Name cannot be empty"),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  controller: TextEditingController(text: description),
                  maxLines: 10,
                  minLines: 1,
                  decoration: InputDecoration(
                      labelText: "Description", hintText: "Description"),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                TextField(
                  controller: TextEditingController(text: price),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      errorText: asBool(price) ? null : "Price cannot be empty",
                      labelText: "Price",
                      hintText: "Price"),
                  onChanged: (value) {
                    price = value;
                  },
                ),
                ElevatedButton(
                    onPressed: (asBool(name) && asBool(price))
                        ? (() async {
                            if (asBool(name) && asBool(price)) {
                              var result = await http.post(
                                  Uri.parse(
                                      '${dotenv.env["API_URL"]}/menu/edit/one'),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonEncode({
                                    'id': widget.id,
                                    "body": {
                                      "name": name,
                                      "description": asBool(description)
                                          ? description
                                          : null,
                                      "price": price,
                                      "pic": image != null ? image : null
                                    }
                                  }));

                              widget.updateFn({
                                "name": name,
                                "description":
                                    asBool(description) ? description : null,
                                "price": price,
                                "pic": image != null ? image : null
                              });

                              Navigator.pop(context);
                            }
                          })
                        : null,
                    child: Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
