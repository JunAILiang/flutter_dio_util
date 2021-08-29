import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpExample extends StatelessWidget {

  void _sendDioGet() async {
    try {
      var response = await http.get(Uri.parse("http://localhost:8080/login?username=Jimi&password=123456"));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HttpExample"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: _sendDioGet,
              child: Text("发送get请求"),
            )
          ],
        ),
      ),
    );
  }
}