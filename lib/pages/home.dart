import 'package:flutter/material.dart';

import './booking.dart';
import './history.dart';
import './notifications.dart';
import './profile.dart';

class HomePage extends StatefulWidget {
  final arguments;

  const HomePage({super.key, this.arguments});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      const BookingPage(),
      HistoryPage(arguments: widget.arguments),
      const NotificationsPage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: const Text('Court Booking',
              style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('ออกจากระบบ'),
                      content: const Text('คุณต้องการออกจากระบบหรือไม่'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('ยกเลิก'),
                          onPressed: () {
                            Navigator.of(context).pop();
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
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _pages[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepPurple,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Booking'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
