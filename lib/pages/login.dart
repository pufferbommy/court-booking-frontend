import 'dart:convert';
import 'package:court_booking/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState();

  final _formKey = GlobalKey<FormState>();

  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: userIdController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'รหัสผู้ใช้'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผู้ใช้';
                        }
                        return null;
                      },
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'รหัสผ่าน'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        return null;
                      },
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var response = await http.post(
                        Uri.parse('$baseUrl/court-management/login.php'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'id': userIdController.text,
                          'password': passwordController.text,
                        }),
                      );
                      bool ok = await jsonDecode(response.body);
                      if (ok) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(content: Text('เข้าสู่ระบบสำเร็จ')),
                          );
                        String userId = userIdController.text;
                        Navigator.of(context)
                            .pushReplacementNamed('/home', arguments: userId);
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                                content:
                                    Text('รหัสผู้ใช้หรือรหัสผ่านไม่ถูกต้อง')),
                          );
                      }
                    } else {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                              content: Text('กรุณากรอกรหัสผู้ใช้และรหัสผ่าน')),
                        );
                    }
                  },
                  child: Text("เข้าสู่ระบบ"),
                )
              ],
            ),
          )),
    );
  }
}
