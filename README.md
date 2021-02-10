# Dart library for RICOH THETA Mobile and Desktop Developers

Based on [THETA Web API v2.1](https://api.ricoh/docs/theta-web-api-v2.1/). For information
on connecting the camera and testing the camera API with a command line tool,
see [RICOH THETA API HTTP Community Tests README](https://github.com/theta360developers/webapi/blob/master/README.md).

This is for education and testing use only and should not be used for production.  Only
a portion of the API has been implemented.  We are using this library
to document usage of the API and show prototypes of concepts such as displaying thumbnails.
We are not to using the library to build production apps.

This project is not connected to any official RICOH project.

## Installation

1. save the packages directory to the root directory of your Flutter or Dart app
2. Add the following dependency to `pubspec.yaml`

```yaml
dependencies:
  theta:
    path: packages/theta
```

3. import the library

```dart
import 'package:theta/theta.dart';
```

### Install from GitHub

Alternately, you can install the package automatically from GitHub without
having to copy the files into your project.  To automatically install from
GitHub, add the following to your `pubspec.yaml` file.

```yaml
dependencies:
  theta:
    git:
      url: https://github.com/codetricity/theta
      ref: main
```

## Example Command Line Use

```dart
...
yourFunction() async {
    print(await Camera.info);
}
```

### Full Program Example

A fully working program showing the `main` top-level function where the Dart
app starts working.

```dart
import 'package:theta/theta.dart';

void main(List<String> args) async {
  print(await Camera.info);
}
```

Assuming the test program is in `./bin/test_temporary.dart`, you can run the program and
see the output with:

```shell
> dart .\bin\test_temporary.dart     
{manufacturer: RICOH, model: RICOH THETA SC2, serialNumber: 20001005, firmwareVersion: 01.51, supportUrl: https://theta360.com/en/support/, gps: false, gyro: true, endpoints: {httpPort: 80, httpUpdatesPort: 80}, apiLevel: [2], api: [/osc/info, /osc/state, /osc/checkForUpdates, /osc/commands/execute, /osc/commands/status], uptime: 2088, _wlanMacAddress: 58:38:79:2b:ad:c5, _bluetoothMacAddress: 
6c:21:a2:47:d9:05}
```

### Formatting Camera Output for Humans to Read

You can format the output with the following conversion where `map` is the output from info.

```dart
JsonEncoder.withIndent('  ').convert(map)
```

Example:

```dart
import 'dart:convert';
import 'package:theta/theta.dart';

String pretty(map) {
  return (JsonEncoder.withIndent('  ').convert(map));
}

void main(List<String> args) async {
  print(pretty(await Camera.info));
}
```

Your output will now have nice indents.

```shell
> dart .\bin\test_temporary.dart
{
  "manufacturer": "RICOH",
  "model": "RICOH THETA SC2",
  "serialNumber": "20001005",
  "firmwareVersion": "01.51",
  "supportUrl": "https://theta360.com/en/support/",
  "gps": false,
  "gyro": true,
  "endpoints": {
    "httpPort": 80,
```

## Example Use with Flutter

[Flutter demo repo](https://github.com/codetricity/theta_webapi_flutter_minimal)

![screenshot of flutter app](https://raw.githubusercontent.com/codetricity/theta_webapi_flutter_minimal/main/docs/images/android_demo.gif)

Full code for demo above from the `main.dart file`.

Note that you likely want to break up your program into separate files
and use state management such as BLoC or Provider in your actual app.
The example uses a stateful widget to show the basic use of the library.

```dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:theta/theta.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THETA API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'THETA API Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String response = '';
  bool textResponse = true;
  String image64 = '';

  void _info() async {
    _displayResponse(await Camera.info);
  }

  void _model() async {
    _displayResponse(await Camera.model);
  }

  void _firmware() async {
    _displayResponse(await Camera.firmware);
  }

  void _takePicture() async {
    _displayResponse(await ThetaRun.takePicture());
  }

  void _state() async {
    _displayResponse(await Camera.state);
  }

  void _displayResponse(mapData) {
    setState(() {
      textResponse = true;
      response = JsonEncoder.withIndent('  ').convert(mapData);
    });
  }

  void _displayThumb() async {
    var imageData = await ThetaFile.getLastThumb64();
    setState(() {
      textResponse = false;
      image64 = imageData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: _info,
                  child: Text('info'),
                  color: Colors.lightGreen,
                ),
                MaterialButton(
                  onPressed: _model,
                  child: Text('model'),
                  color: Colors.lightGreen,
                ),
                MaterialButton(
                  onPressed: _firmware,
                  child: Text('firmware'),
                  color: Colors.lightGreen,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: _state,
                  child: Text('state'),
                  color: Colors.lightGreen,
                ),
                MaterialButton(
                  onPressed: _takePicture,
                  child: Text('take picture'),
                  color: Colors.lightGreen,
                ),
                MaterialButton(
                  onPressed: _displayThumb,
                  child: Text('thumb'),
                  color: Colors.lightGreen,
                ),
              ],
            ),
            textResponse
                ? Text(response)
                : Container(child: Image.memory(base64Decode(image64))),
          ],
        ),
      ),
    );
  }
}
```

