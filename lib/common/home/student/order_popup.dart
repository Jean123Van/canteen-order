import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderPopup extends StatefulWidget {
  final pic;
  final name;
  final amount;
  final productId;
  final userId;
  const OrderPopup(
      {super.key,
      required this.amount,
      required this.name,
      required this.pic,
      required this.productId,
      required this.userId});

  @override
  State<OrderPopup> createState() => _OrderPopupState();
}

class _OrderPopupState extends State<OrderPopup> {
  int quantity = 0;
  bool isLoading = false;
  bool? ordered;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: widget.pic == null
                          ? Icon(Icons.no_food_rounded)
                          : Image.memory(Uint8List.fromList(
                              jsonDecode(widget.pic).cast<int>())),
                      height: 200,
                      width: 200,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      padding:
                          EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 8),
                      child: Text(widget.name),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color.fromARGB(255, 141, 209, 243)),
                    ),
                    Text('₱ ${widget.amount}'),
                    Container(
                      child: Row(
                        children: [
                          InkWell(
                              onTap: (() {
                                setState(() {
                                  quantity++;
                                });
                              }),
                              child: Container(
                                height: 20,
                                width: 30,
                                child: Center(child: Text("+")),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 118, 252, 132)),
                              )),
                          Container(
                            height: 20,
                            width: 30,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  isCollapsed: true, border: InputBorder.none),
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                  text: quantity.toString()),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                quantity = int.parse(value);
                                setState(() {});
                              },
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          InkWell(
                              onTap: (() {
                                if (quantity > 0) {
                                  quantity--;
                                }
                                setState(() {});
                              }),
                              child: Container(
                                height: 20,
                                width: 30,
                                child: Center(child: Text("-")),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 239, 117, 117)),
                              ))
                        ],
                        mainAxisSize: MainAxisSize.min,
                      ),
                    ),
                    ordered == null
                        ? (isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed: quantity == 0
                                    ? null
                                    : (() async {
                                        isLoading = true;
                                        setState(() {});
                                        var result = await http.post(
                                            Uri.parse(
                                                '${dotenv.env["API_URL"]}/order/submit'),
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: jsonEncode({
                                              "productId": widget.productId,
                                              "buyerId": widget.userId,
                                              "quantity": quantity,
                                              "status": "Pending Approval"
                                            }));
                                        if (result.statusCode == 200) {
                                          isLoading = false;
                                          ordered = true;
                                          setState(() {});
                                        }
                                      }),
                                child: Text('Order')))
                        : Container(
                            margin: EdgeInsets.only(top: 5),
                            child: (Text("Check History")),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Color.fromARGB(255, 44, 160, 255)),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
