import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

class HistoryPage extends StatefulWidget {
  final arguments;

  const HistoryPage({super.key, this.arguments});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  _HistoryPageState();

  List<dynamic> histories = [];

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  _loadHistories() async {
    var userId = widget.arguments;
    var response = await http.get(
      Uri.parse('$baseUrl/court-management/histories.php?userId=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonData = await jsonDecode(response.body);
    setState(() {
      histories = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          const Text('ประวัติการจองทั้งหมด', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, index) {
                final history = histories[index];

                DateTime historyDate = DateTime.parse(history['date']);

                DateTime currentDate = DateTime.now();

                bool isCurrentDate = currentDate.year == historyDate.year &&
                    currentDate.month == historyDate.month &&
                    currentDate.day == historyDate.day;

                return ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text((index + 1).toString(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text('Court' + " " + history['court']),
                    subtitle:
                        Text(history['timeRange'] + " on " + history['date']),
                    trailing: Visibility(
                        visible: isCurrentDate,
                        child: IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          onPressed: () async {
                            var bookingId = history['id'];

                            bool confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('ยกเลิกการจอง'),
                                  content: const Text(
                                      'คุณต้องการยกเลิกการจองหรือไม่'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('ยกเลิก'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.deepPurple,
                                            // set color for button
                                          ),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Colors.white,
                                          )),
                                      child: const Text('ยืนยัน'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              await http.delete(
                                Uri.parse(
                                    '$baseUrl/court-management/bookings.php?id=$bookingId'),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                              );
                              _loadHistories();
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text('ยกเลิกการจองสำเร็จ'),
                                  ),
                                );
                            }
                          },
                        )));
              },
            ),
          ),
        ],
      ),
    );
  }
}
