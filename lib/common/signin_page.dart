import 'dart:convert';
import 'package:pickerimagetest/common/home/admin/home_Admin.dart';
import 'package:pickerimagetest/common/home/store/home_store.dart';
import 'package:http/http.dart' as http;
import 'package:pickerimagetest/common/home/student/student_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? name;
  String? password;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in'),
      ),
      body: Container(
          child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "ID Number / Name"),
            onChanged: (value) {
              name = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
          ),
          loading
              ? Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () async {
                    loading = true;
                    setState(() {});
                    var result = await http.post(
                        Uri.parse('${dotenv.env["API_URL"]}/login'),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode({"name": name, "password": password}));

                    if (result.statusCode == 200) {
                      loading = false;
                    }
                    setState(() {});

                    var redirectScreen;

                    if (result.body == '') {
                      redirectScreen = AlertDialog(
                        content: Text("Error Login Please Try Again"),
                      );
                    } else if (jsonDecode(result.body)['type'] == "Student") {
                      redirectScreen = HomePage(
                          userId: jsonDecode(result.body)['id'],
                          name: jsonDecode(result.body)['name']);
                    } else if (jsonDecode(result.body)['type'] == "Admin") {
                      redirectScreen = HomeAdmin();
                    } else if (jsonDecode(result.body)['type'] == "Store") {
                      redirectScreen =
                          HomeStore(userId: jsonDecode(result.body)['id']);
                    }

                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            barrierDismissible: true,
                            opaque: false,
                            pageBuilder:
                                ((context, animation, secondaryAnimation) {
                              return redirectScreen;
                            })));
                  },
                  child: Text('Sign In'))
        ],
      )),
    );
  }
}
