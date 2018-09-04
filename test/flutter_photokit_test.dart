@OnPlatform(const {
  '!ios': const Skip('Plugin only available for iOS')
})

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_photokit/flutter_photokit.dart';

void main() {
  final String mockFilePath = '/sample/file/path.jpg';
  final String mockAlbumName = 'MySampleAlbum';

  group('$FlutterPhotokit', () {
    const MethodChannel channel =
        MethodChannel('flutter_photokit');

    final List<MethodCall> log = <MethodCall>[];

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        return '';
      });

      log.clear();
    });

    group('#saveToAlbum', () {
      test('passes the arguments correctly', () async {
        await FlutterPhotokit.saveToAlbum(filePath: mockFilePath, albumName: mockAlbumName);

        expect(
          log,
          <Matcher>[
            isMethodCall('saveToAlbum', arguments: <String, dynamic>{
              'filePath': mockFilePath,
              'albumName': mockAlbumName,
            }),
          ],
        );
      });
    });

    group('#saveToCameraRoll', () {
      test('passes the arguments correctly', () async {
        await FlutterPhotokit.saveToCameraRoll(filePath: mockFilePath);

        expect(
          log,
          <Matcher>[
            isMethodCall('saveToCameraRoll', arguments: <String, dynamic>{
              'filePath': mockFilePath
            }),
          ],
        );
      });
    });
  });
}
