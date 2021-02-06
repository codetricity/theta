import 'dart:convert';
import 'dart:typed_data';

import 'connect.dart';

class ThetaFile {
  static final String _url = 'http://192.168.1.1/osc/commands/execute';

  static Future<Uint8List> getLastThumbBytes() async {
    var _data = {
      'name': 'camera.listFiles',
      'parameters': {
        'fileType': 'image',
        'entryCount': 1,
        // '_startFileUrl': imageUrl,
        'maxThumbSize': 640,
        '_detail': true,
      }
    };
    var response = await connect(_url, 'post', _data);

    String thumb64 = response['results']['entries'][0]['thumbnail'];
    var thumbBytes = base64Decode(thumb64);
    return thumbBytes;
  }
}
