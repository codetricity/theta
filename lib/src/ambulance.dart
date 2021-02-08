import 'connect.dart';

const String _baseUrl = 'http://192.168.1.1/osc/commands/execute';

/// Emergency or administrative tasks. Reset camera settings,
/// including my settings, delete all files from camera
/// if these commands are in an end-user application, it
/// would be nice to put a confirmation screen up to make
/// sure the person is aware they will delete all their settings.
/// Resetting the camera will also cause the camera to power off.
/// You need to manually turn on the camera again and
/// reconnect the camera back to your computer with Wi-Fi.
/// These tools are great for testing as long as the camera user
/// is aware of what they are doing.
class Ambulance {
  /// reset camera settings.  Camera will reboot.  You must
  /// turn the camera on manually and reconnect to Wi-Fi.
  /// This will not reset my settings.  This also clears
  /// my settings.
  /// https://api.ricoh/docs/theta-web-api-v2.1/commands/camera.reset/
  static Future<Map<String, dynamic>> reset() async {
    var data = {'name': 'camera.reset'};
    var response = connect(_baseUrl, 'post', data);
    return response;
  }

  /// delete all files from camera.  If this doesn't work, try
  /// updating the SC2 firmware.  Older versions had a bug
  /// that prevented the 'all' parameter from working
  static Future<Map<String, dynamic>> deleteAll() async {
    var data = {
      'name': 'camera.delete',
      'parameters': {
        'fileUrls': ['all']
      }
    };
    var response = connect(_baseUrl, 'post', data);
    return response;
  }
}
