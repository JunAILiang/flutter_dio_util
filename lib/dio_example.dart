import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class DioExample extends StatefulWidget {
  @override
  _DioExampleState createState() => _DioExampleState();
}

class _DioExampleState extends State<DioExample> {

  void _handleLogin() async {
    try {
      var response = await Dio().get('http://localhost:8080/login?username=Jimi&password=123456');

      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DioExample"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: _handleLogin,
              child: Text("发送get请求"),
            ),
          ],
        ),
      ),
    );
  }
}

