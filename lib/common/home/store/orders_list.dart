import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OrdersList extends StatefulWidget {
  final userId;
  const OrdersList({super.key, this.userId});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List items = [];
  int page = 1;
  ScrollController controller = ScrollController();
  bool isLoading = true;

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

  fetch() async {
    var result = await http.post(
        Uri.parse('${dotenv.env["API_URL"]}/order/get'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId, "page": page}));

    page++;

    items.addAll(jsonDecode(result.body));
    if ((jsonDecode(result.body) as List).length != 10) {
      isLoading = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
        child: Material(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Column(
                    children: items.map(((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 100,
                                child: item['pic'] == null
                                    ? Icon(Icons.no_food_rounded)
                                    : Image.memory(Uint8List.fromList(
                                        jsonDecode(item['pic']).cast<int>())),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    item['studentname'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(item['studentNo']),
                                  Text(item['name']),
                                  Text(item['quantity'].toString())
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  if (item['status'] == "Pending Approval")
                                    ElevatedButton(
                                        onPressed: () async {
                                          await http.post(
                                              Uri.parse(
                                                  '${dotenv.env["API_URL"]}/order/action'),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                "action": "Accept",
                                                "id": item['id']
                                              }));

                                          var itemsIndex = items.indexOf(item);
                                          items[itemsIndex]['status'] =
                                              "Cooking";

                                          setState(() {});
                                        },
                                        child: Text('Accept')),
                                  if (item['status'] == "Pending Approval")
                                    ElevatedButton(
                                        onPressed: () async {
                                          await http.post(
                                              Uri.parse(
                                                  '${dotenv.env["API_URL"]}/order/action'),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                "action": "Deny",
                                                "id": item['id']
                                              }));

                                          var itemsIndex = items.indexOf(item);
                                          items[itemsIndex]['status'] =
                                              "Denied";

                                          setState(() {});
                                        },
                                        child: Text('Deny')),
                                  if (item['status'] == "Cooking")
                                    ElevatedButton(
                                        onPressed: () async {
                                          await http.post(
                                              Uri.parse(
                                                  '${dotenv.env["API_URL"]}/order/action'),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                "action": "Pick Up",
                                                "id": item['id']
                                              }));

                                          var itemsIndex = items.indexOf(item);
                                          items[itemsIndex]['status'] =
                                              "Pick up from Store";

                                          setState(() {});
                                        },
                                        child: Text('Pick Up')),
                                  if (item['status'] == "Pick up from Store")
                                    ElevatedButton(
                                        onPressed: () async {
                                          await http.post(
                                              Uri.parse(
                                                  '${dotenv.env["API_URL"]}/order/action'),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: jsonEncode({
                                                "action": "Completed",
                                                "id": item['id']
                                              }));
                                          var itemsIndex = items.indexOf(item);
                                          items[itemsIndex]['status'] =
                                              "Completed";

                                          setState(() {});
                                        },
                                        child: Text('Completed')),
                                  if (item['status'] == "Denied")
                                    Text("Order Denied"),
                                  if (item['status'] == "Completed")
                                    Text("Completed"),
                                ],
                              ),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ),
                    ),
                  );
                })).toList()),
                if (isLoading) CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
