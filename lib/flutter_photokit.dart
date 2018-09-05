import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterPhotokit {
  static const MethodChannel _channel = const MethodChannel('flutter_photokit');

  FlutterPhotokit._();

  /// Saves the file at [filePath] to [albumName].
  ///
  /// [filePath] must contain either an image or video file.
  ///
  /// If an album named [albumName] doesn't exist, it will be created.
  static Future<bool> saveToAlbum(
      {@required String filePath, @required String albumName}) async {
    _checkPlatform();

    final bool success = await _channel.invokeMethod('saveToAlbum',
        <String, dynamic>{'filePath': filePath, 'albumName': albumName});

    return success;
  }

  /// Saves the file at [filePath] to the device's camera roll.
  ///
  /// [filePath] must contain either an image or video file.
  static Future<bool> saveToCameraRoll({@required String filePath}) async {
    _checkPlatform();

    final bool success =
        await _channel.invokeMethod('saveToCameraRoll', <String, dynamic>{
      'filePath': filePath,
    });

    return success;
  }

  /// Check that the plugin is being called from an iOS device.
  /// If not, throws an [UnimplementedError]
  static void _checkPlatform() async {
    if (!Platform.isIOS) {
      throw UnimplementedError('This plugin is only available for iOS devices');
    }
  }
}
