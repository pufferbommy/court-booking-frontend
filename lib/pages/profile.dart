import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 8),
        const Text('โปรไฟล์', style: TextStyle(fontSize: 32)),
        const SizedBox(height: 16),
        const Row(children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://is3-ssl.mzstatic.com/image/thumb/9V4D9uXs-9J17kIlN68j3w/1200x675mf.jpg',
            ),
          ),
          SizedBox(width: 32),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'นางสาวเรียนดี รักเรียน',
              ),
              SizedBox(height: 4),
              Text(
                'รหัสสมาชิก 123456',
              ),
            ],
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.deepPurple, borderRadius: BorderRadius.circular(8)),
          child: const Column(
            children: [
              Text('Profile',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              SizedBox(height: 8),
              Text('นางสาวเรียนดี รักเรียน อายุ 20',
                  style: TextStyle(color: Colors.white)),
              Text('วัน/เดือน/ปีเกิด: 23/03/2003',
                  style: TextStyle(color: Colors.white)),
              Text('สำนักวิชา: วิศวกรรมศาสตร์และเทคโนโลยี',
                  style: TextStyle(color: Colors.white)),
              Text('สาขา: วิศวกรรมคอมพิวเตอร์และปัญญาประดิษฐ์',
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
          decoration: BoxDecoration(
              color: Colors.deepPurple, borderRadius: BorderRadius.circular(8)),
          width: double.infinity,
          child: const Column(
            children: [
              Text('Contact',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              SizedBox(height: 8),
              Text('E-mail: -', style: TextStyle(color: Colors.white)),
              Text('Phone: 090-0001200', style: TextStyle(color: Colors.white)),
            ],
          ),
        )
      ],
    ));
  }
}
