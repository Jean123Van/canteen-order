import 'package:pickerimagetest/common/home/student/history.dart';
import 'package:pickerimagetest/common/home/student/order.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final userId;
  final name;
  const HomePage({super.key, this.name, this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var homeValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Welcome ${widget.name}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Logout')),
              )
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      homeValue = true;
                      setState(() {});
                    },
                    child: Text('Order'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: homeValue
                            ? Color.fromARGB(255, 234, 161, 57)
                            : Color.fromARGB(255, 124, 179, 224))),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      homeValue = false;
                      setState(() {});
                    },
                    child: Text('History'),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: !homeValue
                            ? Color.fromARGB(255, 234, 161, 57)
                            : Color.fromARGB(255, 124, 179, 224)))
              ],
            ),
            homeValue == true
                ? Order(userId: widget.userId)
                : History(userId: widget.userId)
          ],
        ));
  }
}
