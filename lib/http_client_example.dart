import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class HttpClientExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    void _getUserInfo() async {
      try {
        // 1. 创建httpClient
        HttpClient httpClient = HttpClient();
        // 2. 打开http连接,设置请求头
        HttpClientRequest request = await httpClient.getUrl(Uri.parse("http://localhost:8080/login?username=Jimi&password=123456"));
        // 3. 通过HttpClientRequest可以设置请求header
        request.headers.add("token", "123456");
        // 4. 等待连接服务器
        HttpClientResponse response = await request.close();
        // 5. 读取响应内容
        String responseBody = await response.transform(utf8.decoder).join();
        // 6. 请求结束,关闭httpClient
        httpClient.close();

        print(responseBody);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("DioExample"),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: _getUserInfo,
              child: Text("发送get请求"),
            )
          ],
        ),
      ),
    );
  }
}
