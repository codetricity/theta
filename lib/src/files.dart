import 'dart:convert';
import 'dart:typed_data';

import 'connect.dart';

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
}
