import 'connect.dart';

const String _baseUrl = 'http://192.168.1.1/osc/';

class Camera {
  /// Camera info including firmware version and camera model
  /// based on GET http://192.168.1.1/osc/info
  ///
  static Future<Map<String, dynamic>> get info async {
    // GET http://192.168.1.1/osc/info
    var url = _baseUrl + 'info';
    var response = connect(url, 'get');
    return response;
  }

  /// internal camera firmware version such as 1.60.1
  static Future<String> get firmware async {
    var cameraInfo = await info;
    return cameraInfo['firmwareVersion'];
  }

  /// camera model such as RICOH THETA SC2
  static Future<String> get model async {
    var cameraInfo = await info;
    return cameraInfo['model'];
  }

  /// request: POST http://192.168.1.1/osc/state
  /// batteryLevel, API version, camera errors, captureStatus, _latestFileUrl
  ///
  static Future<Map<String, dynamic>> get state async {
    var url = _baseUrl + 'state';
    // request: POST http://192.168.1.1/osc/state
    var response = connect(url, 'post');
    return response;
  }

  /// battery charge percentage
  static Future<double> get batteryLevel async {
    var cameraState = await state;
    return cameraState['state']['batteryLevel'];
  }

  /// Camera status.  Requires "id" is passed
  /// POST http://192.168.1.1/osc/commands/status
  /// Get the ID from a command such as takePicture
  static Future<Map<String, dynamic>> status(int id) async {
    //POST http://192.168.1.1/osc/commands/status
    var url = _baseUrl + 'commands/status';

    var body = {'id': id};
    var response = connect(url, 'post', body);
    return response;
  }
}
