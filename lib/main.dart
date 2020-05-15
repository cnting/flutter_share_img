import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show ImageByteFormat, Image, window;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("share"),
        ),
        body: SingleChildScrollView(
          child: RepaintBoundary(
            key: globalKey,
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.blue,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.green,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.red,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.amber,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.cyan,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.deepOrange,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  color: Colors.purpleAccent,
                ),
                RaisedButton(
                  child: Text("点击分享"),
                  onPressed: () {
                    _doShare();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///1.动态拼接一个底部widget
  ///2.生成图片、压缩图片
  ///3.分享图片
  _doShare() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    if(boundary.debugNeedsPaint){
      print("waiting.......");
      await Future.delayed(const Duration(milliseconds: 20));
      return _doShare();
    }
    double dpr = ui.window.devicePixelRatio;
    ui.Image image = await boundary.toImage(pixelRatio: dpr);
    //转二进制
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //保存
    Uint8List source = byteData.buffer.asUint8List();
    Directory dir = await getTemporaryDirectory();
    File file = new File("${dir.path}/share.png");
    print('===>${file.path}');
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsBytesSync(source);
    Share.file("分享标题", "share.png", source, "image/png");
  }
}
