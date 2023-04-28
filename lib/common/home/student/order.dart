import 'dart:convert';

import 'package:pickerimagetest/common/home/student/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Order extends StatefulWidget {
  final userId;
  const Order({super.key, this.userId});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  ScrollController controller = ScrollController();
  var items = [];
  int page = 1;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    var result = await http.post(
        Uri.parse('${dotenv.env["API_URL"]}/menu/get/all'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"page": page}));

    page++;

    if (result.statusCode == 200) {
      if ((jsonDecode(result.body) as List).length != 10) {
        loading = false;
      }
      setState(() {
        items.addAll(jsonDecode(result.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              GridView.builder(
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return OrderTile(
                      amount: items[index]['price'] as String,
                      name: items[index]['name'] as String,
                      pic: items[index]['pic'],
                      userId: widget.userId,
                      productId: items[index]['id']);
                },
                shrinkWrap: true,
              ),
              if (loading) CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
