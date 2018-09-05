import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_photokit/flutter_photokit.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

enum _SaveStatus {
  NONE,
  SAVING,
  SAVED
}

class MyApp extends StatefulWidget {
  const MyApp({ Key key }) : super(key: key);

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _SaveStatus _cameraRollStatus = _SaveStatus.NONE;
  _SaveStatus _albumStatus = _SaveStatus.NONE;
  TextEditingController _albumTextController;

  static HttpClient _httpClient = HttpClient();
  static String _sampleImageUrl = 'https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png';
  // Use this link to test with a video.
  // static String _sampleVideoUrl = 'https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4';

  @override
  void initState() {
    super.initState();

    _albumTextController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  Future<File> _downloadFile(String url) async {
    Uri uri = Uri.parse(url);

    HttpClientRequest req = await _httpClient.getUrl(uri);
    HttpClientResponse res = await req.close();

    List<int> bytes = await consolidateHttpClientResponseBytes(res);
    String tempDir = (await getTemporaryDirectory()).path;
    File outputFile = File('$tempDir/${uri.pathSegments.last}');
    await outputFile.writeAsBytes(bytes);

    return outputFile;
  }

  void _saveToCameraRoll() async {
    setState(() => _cameraRollStatus = _SaveStatus.SAVING);

    File file = await _downloadFile(_sampleImageUrl);
    print('Downloaded file');
    await FlutterPhotokit.saveToCameraRoll(
      filePath: file.path
    );
    print('Saved file to camera roll');

    setState(() => _cameraRollStatus = _SaveStatus.SAVED);
  }

  void _saveToAlbum() async {
    setState(() => _albumStatus = _SaveStatus.SAVING);

    File file = await _downloadFile(_sampleImageUrl);
    print('Downloaded file...');
    await FlutterPhotokit.saveToAlbum(
      filePath: file.path,
      albumName: _albumTextController.value.text
    );
    print('Saved file to album');

    setState(() => _albumStatus = _SaveStatus.SAVED);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Flutter PhotoKit Example'),
        ),
        body: _appBody()
      ),
    );
  }

  Widget _appBody() {
    if (Platform.isIOS) {
      return SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.network(_sampleImageUrl),
            SizedBox(height: 16.0),
            _saveToCameraRollRow(),
            SizedBox(height: 16.0),
            _saveToAlbumRow()
          ],
        )
      );
    } else {
      return Center(
        child: Text('The PhotoKit plugin is only available for iOS!')
      );
    }
  }

  Widget _saveToCameraRollRow() {
    switch (_cameraRollStatus) {
      case _SaveStatus.NONE:
        return RaisedButton(
          onPressed: _saveToCameraRoll,
          child: Text('Save to Camera Roll')
        );
      case _SaveStatus.SAVING:
        return CircularProgressIndicator();
      case _SaveStatus.SAVED:
        return Icon(
          Icons.check
        );
    }
  }

  Widget _saveToAlbumRow() {
    switch (_albumStatus) {
      case _SaveStatus.NONE:
        return Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _albumTextController,
                decoration: InputDecoration(
                  labelText: 'Album name'
                )
              ),
            ),
            RaisedButton(
              onPressed: _albumTextController.value.text.trim().isEmpty
                ? null
                : _saveToAlbum,
              child: Text('Save to album'),
            )
          ],
        );
      case _SaveStatus.SAVING:
        return CircularProgressIndicator();
      case _SaveStatus.SAVED:
        return Icon(
          Icons.check
        );
    }
  }
}
