import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'edit_product.dart';

class ManageProduct extends StatefulWidget {
  final userId;
  const ManageProduct({super.key, this.userId});

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  List items = [];
  ScrollController controller = ScrollController();
  bool isLoading = true;
  int page = 1;

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
        Uri.parse('${dotenv.env["API_URL"]}/menu/get/all'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": widget.userId, "page": page}));

    page++;

    if (result.statusCode == 200) {
      items.addAll(jsonDecode(result.body));
      if ((jsonDecode(result.body) as List).length != 10) {
        isLoading = false;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: controller,
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
                              Text(item['name']),
                              Text(
                                item['description'] == null
                                    ? ''
                                    : item['description'],
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('₱ ${item['price']}')
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                            barrierDismissible: true,
                                            opaque: false,
                                            barrierColor: Color.fromARGB(
                                                88, 160, 224, 241),
                                            pageBuilder: ((context, animation,
                                                secondaryAnimation) {
                                              return EditProduct(
                                                  userId: widget.userId,
                                                  id: item['id'],
                                                  updateFn: (newValue) {
                                                    var index =
                                                        items.indexOf(item);

                                                    items[index]['name'] =
                                                        newValue['name'];
                                                    items[index]
                                                            ['description'] =
                                                        newValue['description'];
                                                    items[index]['price'] =
                                                        newValue['price'];
                                                    items[index]['pic'] =
                                                        newValue['pic'];

                                                    setState(() {});
                                                  });
                                            })));
                                  },
                                  child: Text('Edit')),
                              ElevatedButton(
                                  onPressed: () async {
                                    await http.post(
                                        Uri.parse(
                                            '${dotenv.env["API_URL"]}/menu/remove'),
                                        headers: {
                                          "Content-Type": "application/json"
                                        },
                                        body: jsonEncode({"id": item['id']}));

                                    items.remove(item);
                                    setState(() {});
                                  },
                                  child: Text('Delete'))
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
    );
  }
}
