import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  _BookingPageState();

  Map<String, Map<String, Map<String, dynamic>>> courtStatues = {
    '1': {
      '18:00 - 18:30': {'isBooked': false, 'bookedBy': ''},
      '18:30 - 19:00': {'isBooked': false, 'bookedBy': ''},
      '19:00 - 19:30': {'isBooked': false, 'bookedBy': ''},
      '19:30 - 20:00': {'isBooked': false, 'bookedBy': ''},
    },
    '2': {
      '18:00 - 18:30': {'isBooked': false, 'bookedBy': ''},
      '18:30 - 19:00': {'isBooked': false, 'bookedBy': ''},
      '19:00 - 19:30': {'isBooked': false, 'bookedBy': ''},
      '19:30 - 20:00': {'isBooked': false, 'bookedBy': ''},
    },
    '3': {
      '18:00 - 18:30': {'isBooked': false, 'bookedBy': ''},
      '18:30 - 19:00': {'isBooked': false, 'bookedBy': ''},
      '19:00 - 19:30': {'isBooked': false, 'bookedBy': ''},
      '19:30 - 20:00': {'isBooked': false, 'bookedBy': ''},
    },
    '4': {
      '18:00 - 18:30': {'isBooked': false, 'bookedBy': ''},
      '18:30 - 19:00': {'isBooked': false, 'bookedBy': ''},
      '19:00 - 19:30': {'isBooked': false, 'bookedBy': ''},
      '19:30 - 20:00': {'isBooked': false, 'bookedBy': ''},
    },
  };

  @override
  void initState() {
    super.initState();
    _loadCourtStatus();
  }

  Future<void> _loadCourtStatus() async {
    var response = await http.get(
      Uri.parse('$baseUrl/court-management/court-statuses.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var jsonData = await jsonDecode(response.body);
    setState(() {
      courtStatues.updateAll((key1, value1) {
        value1.updateAll((key2, value2) {
          value2['isBooked'] = jsonData[key1][key2]['isBooked'];
          value2['bookedBy'] = jsonData[key1][key2]['bookedBy'];
          return value2;
        });
        return value1;
      });
    });
  }

  Future<void> _showAlertDialog(
      {userId = String, court = int, timeRange = String}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการจอง'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Court $court เวลา $timeRange'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
                _loadCourtStatus();
              },
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurple,
                    // set color for button
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  )),
              child: const Text('ยืนยัน'),
              onPressed: () async {
                Navigator.of(context).pop();
                var response = await http.post(
                  Uri.parse('$baseUrl/court-management/bookings.php'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode({
                    'userId': userId,
                    'court': court,
                    'timeRange': timeRange,
                  }),
                );
                bool ok = await jsonDecode(response.body);
                if (ok) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('จองสำเร็จ')),
                    );
                  _loadCourtStatus();
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                          content: Text('จองไม่สำเร็จ กรุณาลองใหม่อีกครั้ง')),
                    );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
          const SizedBox(height: 8),
          const Text('จองสนามวันนี้', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 16),
          Row(children: [
            Row(
              children: <Widget>[
                Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black45,
                    )),
                const SizedBox(width: 8),
                const Text('สนามว่าง'),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: <Widget>[
                Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.green.shade500,
                    )),
                const SizedBox(width: 8),
                const Text('สนามถูกจอง'),
              ],
            ),
          ]),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Court 1', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['1']?['18:00 - 18:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 1,
                              timeRange: '18:00 - 18:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['1']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:00 - 18:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['1']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['1']?['18:00 - 18:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['1']?['18:30 - 19:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 1,
                              timeRange: '18:30 - 19:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['1']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:30 - 19:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['1']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['1']?['18:30 - 19:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['1']?['19:00 - 19:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 1,
                              timeRange: '19:00 - 19:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['1']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:00 - 19:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['1']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['1']?['19:00 - 19:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['1']?['19:30 - 20:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 1,
                              timeRange: '19:30 - 20:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['1']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:30 - 20:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['1']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['1']?['19:30 - 20:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Court 2', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['2']?['18:00 - 18:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 2,
                              timeRange: '18:00 - 18:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['2']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:00 - 18:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['2']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['2']?['18:00 - 18:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['2']?['18:30 - 19:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 2,
                              timeRange: '18:30 - 19:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['2']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:30 - 19:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['2']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['2']?['18:30 - 19:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['2']?['19:00 - 19:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 2,
                              timeRange: '19:00 - 19:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['2']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:00 - 19:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['2']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['2']?['19:00 - 19:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['2']?['19:30 - 20:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 2,
                              timeRange: '19:30 - 20:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['2']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:30 - 20:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['2']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['2']?['19:30 - 20:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Court 3', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['3']?['18:00 - 18:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 3,
                              timeRange: '18:00 - 18:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['3']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:00 - 18:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['3']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['3']?['18:00 - 18:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['3']?['18:30 - 19:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 3,
                              timeRange: '18:30 - 19:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['3']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:30 - 19:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['3']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['3']?['18:30 - 19:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['3']?['19:00 - 19:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 3,
                              timeRange: '19:00 - 19:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['3']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:00 - 19:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['3']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['3']?['19:00 - 19:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['3']?['19:30 - 20:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 3,
                              timeRange: '19:30 - 20:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['3']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:30 - 20:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['3']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['3']?['19:30 - 20:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Court 4', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['4']?['18:00 - 18:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 4,
                              timeRange: '18:00 - 18:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['4']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:00 - 18:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['4']?['18:00 - 18:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['4']?['18:00 - 18:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['4']?['18:30 - 19:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 4,
                              timeRange: '18:30 - 19:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['4']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('18:30 - 19:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['4']?['18:30 - 19:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['4']?['18:30 - 19:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['4']?['19:00 - 19:30']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 4,
                              timeRange: '19:00 - 19:30');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['4']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:00 - 19:30',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['4']?['19:00 - 19:30']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['4']?['19:00 - 19:30']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          if (courtStatues['4']?['19:30 - 20:00']
                                  ?['isBooked'] ==
                              true) return;
                          _showAlertDialog(
                              userId: userId,
                              court: 4,
                              timeRange: '19:30 - 20:00');
                        },
                        child: Container(
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: courtStatues['4']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true
                                ? Colors.green.shade500
                                : Colors.black45,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('19:30 - 20:00',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                if (courtStatues['4']?['19:30 - 20:00']
                                        ?['isBooked'] ==
                                    true)
                                  Text(
                                      courtStatues['4']?['19:30 - 20:00']
                                          ?['bookedBy'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                              ]),
                        )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ])));
  }
}
