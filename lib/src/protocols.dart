import 'connect.dart';

const String _baseUrl = 'http://192.168.1.1/osc/';

/// Camera state, status, and info. Also grab specific values such as
/// batteryLevel, firmware, model. Roughly correspends to the _Protocols_
/// section of the [THETA Web API v2.1 reference](https://api.ricoh/docs/theta-web-api-v2.1/)
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

  /// request: POST `http://192.168.1.1/osc/state`
  /// batteryLevel, API version, camera errors, captureStatus, _latestFileUrl
  /// Example output converted from a Dart map to JSON for indented display.
  /// Although the camera returns JSON, the output of this `state` command
  /// is a Dart map, not JSON.
  /// ```json
  /// {
  /// "fingerprint": "FIG_0001",
  /// "state": {
  ///   "batteryLevel": 0.8,
  ///   "storageUri": "http://192.168.1.1/files/thetasc26c21a247d9055838792badc5",
  ///   "_apiVersion": 2,
  ///   "_batteryState": "charged",
  ///   "_cameraError": [],
  ///   "_captureStatus": "idle",
  ///   "_capturedPictures": 0,
  ///   "_latestFileUrl": "http://192.168.1.1/files/thetasc26c21a247d9055838792badc5/100RICOH/R0010361.JPG",
  ///   "_recordableTime": 0,
  ///   "_recordedTime": 0,
  ///   "_function": "normal"
  ///  }
  ///}
  /// ```
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

  /// return current fingerprint. check for changes to the
  /// camera state from the `/osc/state` object

  static Future<void> checkForUpdates(fingerprint) async {
    var url = _baseUrl + 'checkForUpdates';
    // request: POST http://192.168.1.1/osc/checkForUpdates
    var body = {'stateFingerprint': fingerprint};

    var response = await connect(url, 'post', body);
    print(response);
    // return response.toString();
  }

  /// Camera status.  Requires "id" is passed
  /// POST http://192.168.1.1/osc/commands/status
  /// Get the ID from a command such as takePicture
  /// for the SC2 and SC2B, this won't work for startCapture, only
  /// for takePicture.  If you take bracketed or interval shooting,
  /// with the SC2 you need to use /osc/state to check when the camera
  /// is ready for the next command
  static Future<Map<String, dynamic>> status(int id) async {
    //POST http://192.168.1.1/osc/commands/status
    var url = _baseUrl + 'commands/status';

    var body = {'id': id};
    var response = connect(url, 'post', body);
    return response;
  }
}
