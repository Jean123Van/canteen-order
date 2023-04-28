import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pickerimagetest/common/register/register_page.dart';
import 'package:pickerimagetest/common/signin_page.dart';
import 'package:flutter/material.dart';

import 'common/home/student/history_tile.dart';
import 'common/register/register.dart';

import 'package:http/http.dart' as http;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Canteen'),
        ),
        body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return SignIn();
                      }));
                    },
                    child: Text('Signin')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return Register();
                      }));
                    },
                    child: Text('Register'))
              ],
            )));
  }
}
