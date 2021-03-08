import 'dart:convert';

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

  // set options from JSON string
  static Future<Map<String, dynamic>> setOptionJson(options) {
    var data = {
      'name': 'camera.setOptions',
      'parameters': {'options': jsonDecode(options)}
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// set option with single parameter
  static Future<Map<String, dynamic>> setOption(
      String optionName, dynamic optionValue) async {
    // print('option received is $optionValue of type ${optionValue.runtimeType}');
    var parsedValue;
    if (optionValue.runtimeType == String) {
      parsedValue = double.tryParse(optionValue) ?? -1111;
      if (parsedValue == -1111) {
        parsedValue = optionValue;
      }
    } else if (optionValue.runtimeType == double ||
        optionValue.runtimeType == int) {
      parsedValue = optionValue;
    } else {
      parsedValue = optionValue;
    }

    var data = {
      'name': 'camera.setOptions',
      'parameters': {
        'options': {optionName: parsedValue}
      }
    };
    var response = connect(_url, 'post', data);
    return response;
    // return {'test': 'testdata'};
  }

  /// get option with single parameter
  static Future<Map<String, dynamic>> getOption(String optionName) async {
    var data = {
      'name': 'camera.getOptions',
      'parameters': {
        'optionNames': [optionName]
      }
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// set my settings.  only saves a single option
  /// the camera API accepts multiple options as a list
  /// will only set values for image mode right now
  /// Does not set mode to video in this command.
  /// The SC2 will load my settings on power on and if the Wi-Fi connection
  /// is dropped.  The Z1 loads my settings when you push the Fn button
  /// a few times.  The icon MY will appear on the OLED.
  static Future<Map<String, dynamic>> setMySetting(
      String optionName, dynamic optionValue) async {
    print('option received is $optionValue of type ${optionValue.runtimeType}');
    var parsedValue;
    if (optionValue.runtimeType == String) {
      parsedValue = double.tryParse(optionValue) ?? -1111;
      if (parsedValue == -1111) {
        // print('setting string');
        parsedValue = optionValue;
        // print('parsed value is $parsedValue');
      }
    } else if (optionValue.runtimeType == double ||
        optionValue.runtimeType == int) {
      parsedValue = optionValue;
    } else {
      parsedValue = optionValue;
    }

    var data = {
      'name': 'camera._setMySetting',
      'parameters': {
        'options': {
          optionName: parsedValue,
        },
        'mode': 'image'
      }
    };
    var response = connect(_url, 'post', data);
    return response;
    // return {'test': 'testdata'};
  }

  static Future<Map<String, dynamic>> setMySettingVideo(
      String optionName, dynamic optionValue) async {
    print('option received is $optionValue of type ${optionValue.runtimeType}');
    var parsedValue;
    if (optionValue.runtimeType == String) {
      parsedValue = double.tryParse(optionValue) ?? -1111;
      if (parsedValue == -1111) {
        // print('setting string');
        parsedValue = optionValue;
        // print('parsed value is $parsedValue');
      }
    } else if (optionValue.runtimeType == double ||
        optionValue.runtimeType == int) {
      parsedValue = optionValue;
    } else {
      parsedValue = optionValue;
    }

    var data = {
      'name': 'camera._setMySetting',
      'parameters': {
        'options': {
          optionName: parsedValue,
        },
        'mode': 'video'
      }
    };
    var response = connect(_url, 'post', data);
    return response;
    // return {'test': 'testdata'};
  }

  /// get my settings image mode
  /// The syntax is different on S and SC
  /// This will only work on V, Z1, SC2, and SC2B
  static Future<Map<String, dynamic>> getMySetting() async {
    var data = {
      'name': 'camera._getMySetting',
      'parameters': {'mode': 'image'}
    };
    var response = connect(_url, 'post', data);
    return response;
  }

  /// get my settings video mode
  /// The syntax is different on S and SC
  /// This will only work on V, Z1, SC2, and SC2B
  static Future<Map<String, dynamic>> getMySettingVideo() async {
    var data = {
      'name': 'camera._getMySetting',
      'parameters': {'mode': 'video'}
    };
    var response = connect(_url, 'post', data);
    return response;
  }
}
