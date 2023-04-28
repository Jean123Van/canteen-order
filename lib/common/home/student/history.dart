import 'dart:convert';

import 'package:pickerimagetest/common/home/student/history_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;

class History extends StatefulWidget {
  final userId;
  const History({super.key, this.userId});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool loading = true;
  List items = [];
  int page = 1;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    fetch();

    controller.addListener(
      (() {
        if (controller.position.maxScrollExtent == controller.offset) {
          fetch();
        }
      }),
    );
  }

  fetch() async {
    var result = await http.post(
        Uri.parse('${dotenv.env["API_URL"]}/order/getall'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId, "page": page}));

    page++;

    if (result.statusCode == 200) {
      if ((jsonDecode(result.body) as List).length != 10) {
        loading = false;
      }
      items.addAll((jsonDecode(result.body) as List));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return HistoryTile(
                        name: items[index]['name'] as String,
                        price: items[index]['price'] as String,
                        quantity: items[index]['quantity'],
                        status: items[index]['status'],
                        pic: items[index]['pic']);
                  },
                  shrinkWrap: true,
                ),
                if (loading) CircularProgressIndicator()
              ],
            )));
  }
}
