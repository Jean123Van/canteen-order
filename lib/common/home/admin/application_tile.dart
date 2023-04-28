import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:asbool/asbool.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApplicationTile extends StatefulWidget {
  final item;
  final updateParent;
  const ApplicationTile({super.key, this.item, this.updateParent});

  @override
  State<ApplicationTile> createState() => _ApplicationTileState();
}

class _ApplicationTileState extends State<ApplicationTile> {
  var imageBytes;
  var decoded;

  @override
  Widget build(BuildContext context) {
    imageBytes = Uint8List.fromList(jsonDecode(widget.item['pic']).cast<int>());

    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              elevation: 4,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: RotatedBox(
                        child: Image.memory(imageBytes),
                        quarterTurns:
                            snapshot.data!.height > snapshot.data!.width
                                ? 3
                                : 0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.item['name']),
                      if (asBool(widget.item['studentNo']))
                        Text(widget.item['studentNo'])
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (() async {
                          await http.post(
                              Uri.parse(
                                  '${dotenv.env["API_URL"]}/applications/approve'),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode({
                                "id": widget.item['id'],
                              }));
                          widget.updateParent();
                        }),
                        child: Text('Approve'),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 99, 194, 226)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: (() async {
                            await http.post(
                                Uri.parse(
                                    '${dotenv.env["API_URL"]}/applications/reject'),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  "id": widget.item['id'],
                                }));
                            widget.updateParent();
                          }),
                          child: Text('Reject'),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Color.fromARGB(255, 243, 116, 116)))
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      }),
      future: decodeImageFromList(imageBytes),
    );
  }
}
