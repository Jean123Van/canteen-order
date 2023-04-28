import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final String name;
  final String price;
  final quantity;
  final status;
  final pic;
  const HistoryTile(
      {super.key,
      required this.name,
      required this.price,
      required this.quantity,
      required this.pic,
      this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        elevation: 5,
        child: Container(
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: 80,
                  height: 80,
                  child: pic == null
                      ? Icon(Icons.no_food_rounded)
                      : Image.memory(
                          Uint8List.fromList(jsonDecode(pic).cast<int>()))),
              Column(
                children: [
                  Text(name),
                  Text(price),
                  Text(quantity.toString()),
                ],
              ),
              Text(status)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
    );
  }
}
