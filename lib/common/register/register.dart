import 'package:pickerimagetest/common/register/register_as_admin.dart';
import 'package:pickerimagetest/common/register/register_as_store.dart';
import 'package:pickerimagetest/common/register/register_as_student.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder:
                              ((context, animation, secondaryAnimation) =>
                                  RegisterAsAdmin())));
                },
                child: Text('As Admin')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder:
                              ((context, animation, secondaryAnimation) =>
                                  RegisterAsStore())));
                },
                child: Text('As Store')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder:
                              ((context, animation, secondaryAnimation) =>
                                  RegisterAsStudent())));
                },
                child: Text('As Student'))
          ],
        ),
      ),
    );
  }
}
