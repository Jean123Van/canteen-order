import 'dart:convert';

import 'package:pickerimagetest/common/home/admin/application_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<String> dropDownItems = ["Student", "Admin", "Store"];
  String dropDownValue = "Student";
  var applications;

  updateParent() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();

    // applications = http
    //     .post(Uri.parse('${dotenv.env["API_URL"]}/applications'),
    //         headers: {"Content-Type": "application/json"},
    //         body: jsonEncode({"type": dropDownValue}))
    //     .then((value) => value.body);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Welcome Admin"),
            ElevatedButton(
                onPressed: (() {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
                child: Text('Logout'))
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            DropdownButton(
              items: dropDownItems
                  .map((item) => DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      ))
                  .toList(),
              onChanged: ((value) {
                dropDownValue = value!;
                setState(() {});
              }),
              value: dropDownValue,
            ),
            FutureBuilder(
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List list = jsonDecode(snapshot.data as String);

                  return Container(
                    child: Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                          children: list
                              .map((item) => ApplicationTile(
                                    item: item,
                                    updateParent: updateParent,
                                  ))
                              .toList()),
                    )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
              future: http
                  .post(Uri.parse('${dotenv.env["API_URL"]}/applications'),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode({"type": dropDownValue}))
                  .then((value) => value.body),
            )
          ],
        ),
      ),
    );
  }
}
