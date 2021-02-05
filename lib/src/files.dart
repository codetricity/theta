import 'connect.dart';

class ThetaFile {
  static final String _url = 'http://192.168.1.1/osc/commands/execute';

  static Future<String> getLastThumb64() async {
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
    return thumb64;
  }
}
