import 'dart:convert';
import 'dart:io';

import 'package:asbool/asbool.dart';
import 'package:pickerimagetest/common/home/store/add_product.dart';
import 'package:pickerimagetest/common/home/store/manage_product.dart';
import 'package:pickerimagetest/common/home/store/orders_list.dart';
import 'package:pickerimagetest/common/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeStore extends StatefulWidget {
  final userId;
  const HomeStore({super.key, this.userId});

  @override
  State<HomeStore> createState() => _HomeStoreState();
}

class _HomeStoreState extends State<HomeStore> {
  bool addProd = true;
  bool manageProd = false;
  bool orders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome Store Owner'),
              ElevatedButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
                  child: Text("Logout"))
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (() {
                    addProd = true;
                    manageProd = false;
                    orders = false;
                    setState(() {});
                  }),
                  child: Text('Add Product'),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: addProd
                          ? Color.fromARGB(255, 234, 161, 57)
                          : Color.fromARGB(255, 124, 179, 224)),
                ),
                TextButton(
                    onPressed: (() {
                      manageProd = true;
                      addProd = false;
                      orders = false;
                      setState(() {});
                    }),
                    child: Text('Manage Product'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: manageProd
                            ? Color.fromARGB(255, 234, 161, 57)
                            : Color.fromARGB(255, 124, 179, 224))),
                TextButton(
                    onPressed: (() {
                      manageProd = false;
                      addProd = false;
                      orders = true;

                      setState(() {});
                    }),
                    child: Text('Orders'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: orders
                            ? Color.fromARGB(255, 234, 161, 57)
                            : Color.fromARGB(255, 124, 179, 224)))
              ],
            ),
            if (addProd) AddProduct(userId: widget.userId),
            if (manageProd) ManageProduct(userId: widget.userId),
            if (orders) OrdersList(userId: widget.userId)
          ],
        ));
  }
}
