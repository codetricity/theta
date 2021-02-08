import 'connect.dart';

const String _url = 'http://192.168.1.1/osc/commands/execute';

/// HDR, exposure, shutter speed, and many other functions are "options".
/// Camera options correspond to the long list of options
/// on the official API specification.
class CameraOption {
  /// Turn on hdr filter
  static Future<Map<String, dynamic>> hdrSet() async {
    var data = {
      'name': 'camera.setOptions',
      'parameters': {
        'options': {
          '_filter': 'hdr',
        }
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// turn off filter, incuding hdr, DR Comp, Noise Reduction, Hh hdr
  static Future<Map<String, dynamic>> filterOff() async {
    var data = {
      'name': 'camera.setOptions',
      'parameters': {
        'options': {
          '_filter': 'off',
        }
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// exposure program is documented [here](https://api.ricoh/docs/theta-web-api-v2.1/options/exposure_program/)
  /// Must be one of 1, 2, 3, 4, 9.
  /// * 1 : Manual program -  Manually set the ISO sensitivity (iso) setting,
  /// shutter speed (shutterSpeed) and aperture (aperture, RICOH THETA Z1 or later).
  /// * 2 : Normal program - Exposure settings are all set automatically.
  /// * 3 : Aperture priority program -  Manually set the aperture (aperture).
  /// RICOH THETA Z1 or later.
  /// * 4 : Shutter priority program - Manually set the shutter speed (shutterSpeed).
  /// * 5 : 	ISO priority program - Manually set the ISO sensitivity (iso) setting.
  static Future<Map<String, dynamic>> setExposureProgram(programValue) async {
    var data = {
      'name': 'camera.setOptions',
      'parameters': {
        'options': {
          'exposureProgram': int.parse(programValue),
        }
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// save hdr filter setting to my settings to survive
  /// camera reboot
  static Future<Map<String, dynamic>> hdrSave() async {
    var data = {
      'name': 'camera._setMySetting',
      'parameters': {
        'options': {
          '_filter': 'hdr',
        },
        'mode': 'image'
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// Turn off filter in mySetting
  static Future<Map<String, dynamic>> filterSavedOff() async {
    var data = {
      'name': 'camera._setMySetting',
      'parameters': {
        'options': {
          '_filter': 'off',
        },
        'mode': 'image'
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// get current filter settings
  static Future<Map<String, dynamic>> get filterSetting async {
    var data = {
      'name': 'camera.getOptions',
      'parameters': {
        'optionNames': ['_filter']
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// get  filter saved settings
  static Future<Map<String, dynamic>> get filterSavedSetting async {
    var data = {
      'name': 'camera._getMySetting',
      'parameters': {
        'optionNames': ['_filter'],
        'mode': 'image'
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// auto sleep. requires a number between 60 and 65535
  /// the default value is 300 seconds or 5 minutes
  /// A value of 65535 will disable sleep
  static Future<Map<String, dynamic>> sleepDelay(int seconds) async {
    var data = {
      'name': 'camera.setOptions',
      'parameters': {
        'options': {'sleepDelay': seconds}
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// auto power off. requires a number between 60 and 65535
  /// 60 will power off the camera after 60 seconds or 1 minute
  /// The default is 600 seconds or 10 minutes
  /// A value of 65535 will disable auto power off
  static Future<Map<String, dynamic>> offDelay(int seconds) async {
    var data = {
      'name': 'camera.setOptions',
      'parameters': {
        'options': {'offDelay': seconds}
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }
}
