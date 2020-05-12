import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:huaweiyunobs/huaweiyunobs.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  String imageurl;
  @override
  void initState() {
    super.initState();
    imageurl = "未知";
    // initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    // Platform messages may fail, so we use a try/catch PlatformException.
    String path = _image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    try {
      imageurl = await Huaweiyunobs.uploadfiles({
        "endPoint": "obs.cn-east-2.myhwclouds.com",
        "ak": "BSFIQ09OUFNADK4FAZGW",
        "sk": "YGFAtdS5b2jYz791kgaNg6S2MSu0t98x373gBZiY",
        "bucketname": "mitoufiles",
        "objectname": "ceshi/" + name,
        "filepath": _image.path
      });
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('上传图片到华为云，返回的图片地址为: $imageurl\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: initPlatformState,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
