import 'dart:async';

import 'package:flutter/services.dart';

class Huaweiyunobs {
  static const MethodChannel _channel = const MethodChannel('huaweiyunobs');

  /**
   *    params 包涵
   *    endPoint
   *    ak
   *    sk
   *    bucketname
   *    objectname
   *    filepath
   */
  static Future<String> uploadfiles(Map params) async {
    final String url =
        await _channel.invokeMethod('_uploadFileToHuaWeiYun', params);
    return url;
  }
}
