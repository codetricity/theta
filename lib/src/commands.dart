import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'connect.dart';

const String _url = 'http://192.168.1.1/osc/commands/execute';
const Map<String, String> _headers = {
  'Content-Type': 'application/json;charset=utf-8'
};

class ThetaRun {
  /// take picture
  /// https://api.ricoh/docs/theta-web-api-v2.1/commands/camera.take_picture/
  static Future<Map<String, dynamic>> takePicture() async {
    var data = {'name': 'camera.takePicture'};
    //encode Map to JSON
    var body = jsonEncode(data);
    var response = await http.post(_url, headers: _headers, body: body);
    var responseBody = jsonDecode(response.body);
    return responseBody;
  }

  /// stop capture.  for continuous interval shooting, returns list of
  /// URLs.
  static Future<Map<String, dynamic>> stopCapture() async {
    var _data = {
      'name': 'camera.stopCapture',
    };
    var response = await connect(_url, 'post', _data);
    return response;
  }
}
