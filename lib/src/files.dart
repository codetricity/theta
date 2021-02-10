import 'dart:convert';
import 'dart:typed_data';

import 'connect.dart';
import 'package:http/http.dart' as http;

/// Get and manage image and video files and thumbnails. Media
/// files on the RICOH THETA are accessible by URLs. The thumbnails
/// are base64 encoded strings in the file listing.
class ThetaFile {
  static final String _url = 'http://192.168.1.1/osc/commands/execute';

  /// returns a Unint8List integer list of a single thumbnail that can be saved
  /// to local storage as a 7K JPEG image or displayed on the mobile device
  /// screen. This is to test if the last image was taken successfully and
  /// also provide some clue as to image settings such as exposure.
  /// Using Dart command line programs (not Flutter), you can save to local
  /// storage with:
  /// ```dart
  ///  async {
  ///    await File('thumbnail.jpg')
  ///        .writeAsBytes(await ThetaFile.getLastThumbBytes());
  ///  }
  /// ```
  ///
  /// Displaying the image on Flutter.
  ///
  /// method that is called when a button is pressed.
  ///
  /// ```dart
  /// import 'package:theta/theta.dart';
  /// ...
  ///   void _displayThumb() async {
  ///  var imageData = await ThetaFile.getLastThumbBytes();
  ///  setState(() {
  ///    textResponse = false;
  ///    imageBytes = imageData;
  ///  });
  /// }
  /// ```
  ///
  /// To display the image on the Flutter screen
  ///
  /// ```dart
  /// Image.memory(imageBytes)
  /// ```
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

  /// total number of image and video files on camera
  ///
  static Future<int> get totalEntries async {
    var _data = {
      'name': 'camera.listFiles',
      'parameters': {
        'fileType': 'image',
        'entryCount': 1,
        'maxThumbSize': 0,
        '_detail': false,
      }
    };
    var response = await connect(_url, 'post', _data);

    return response['results']['totalEntries'];
  }

  /// List of the URLs for the images and video on the THETA camera
  /// This can be useful for testing as most editors and terminals
  /// allow you to ctrl-click on the url to view it in a browser such
  /// as chrome. You need to pass listUrls the entry count.  You can
  /// get the total entry count with ThetaFile.totalEntries
  /// Example:
  /// ```dart
  /// print(pretty(await ThetaFile.listUrls(await ThetaFile.totalEntries)));
  /// ```

  static Future<List<String>> listUrls(int entryCount) async {
    var _data = {
      'name': 'camera.listFiles',
      'parameters': {
        'fileType': 'image',
        'entryCount': entryCount,
        'maxThumbSize': 0,
        '_detail': false,
      }
    };
    var response = await connect(_url, 'post', _data);
    var entries = response['results']['entries'];

    //ignore: omit_local_variable_types
    List<String> urls = [];

    entries.forEach((element) {
      urls.add(element['fileUrl']);
    });

    return urls;
  }

  static Future<List<dynamic>> getThumbs(int number) async {
    //ignore: omit_local_variable_types
    List<String> listOfUrls = await listUrls(number);
    var thumbs = [];
    var headers = {'Content-Type': 'application/json;charset=utf-8'};
    var client = http.Client();

    try {
      // var response2 = await client.get(
      //     'http://192.168.1.1/files/thetasc26c21a247d9055838792badc5/100RICOH/R0010343.JPG?type=thumb',
      //     headers: headers);
      // print(response2.statusCode);
      // thumbs.add(response2.bodyBytes);
      // listOfUrls.forEach((url) async {
      for (var i = 0; i < listOfUrls.length; i++) {
        print(listOfUrls[i]);
        var response =
            await client.get('${listOfUrls[i]}?type=thumb', headers: headers);
        print(response.statusCode);
        thumbs.add(response.bodyBytes);
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
    print(thumbs.length);

    return thumbs;
  }
}
