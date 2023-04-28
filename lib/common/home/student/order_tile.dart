import 'dart:convert';

import 'package:pickerimagetest/common/home/student/order_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OrderTile extends StatefulWidget {
  final String amount;
  final String name;
  final pic;
  final userId;
  final productId;
  const OrderTile(
      {super.key,
      required this.amount,
      required this.name,
      this.pic,
      this.userId,
      this.productId});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  int quantity = 0;
  // TextEditingController? controller;

  @override
  void initState() {
    super.initState();

    // controller = TextEditingController(text: quantity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                barrierDismissible: true,
                opaque: false,
                pageBuilder: ((context, animation, secondaryAnimation) {
                  return OrderPopup(
                    pic: widget.pic,
                    name: widget.name,
                    userId: widget.userId,
                    productId: widget.productId,
                    amount: widget.amount,
                  );
                })));
      },
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        elevation: 5,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: widget.pic == null
                      ? Icon(Icons.no_food_rounded)
                      : Image.memory(Uint8List.fromList(
                          jsonDecode(widget.pic).cast<int>())),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3),
                padding: EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                child: Text(widget.name),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color.fromARGB(255, 141, 209, 243)),
              ),
              Text('₱ ${widget.amount}'),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
