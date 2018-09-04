import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPhotokit {
  static const MethodChannel _channel =
      const MethodChannel('flutter_photokit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
