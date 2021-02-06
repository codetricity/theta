# A library for RICOH THETA Developers

Based on [THETA Web API v2.1](https://api.ricoh/docs/theta-web-api-v2.1/)

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

## Example Command Line Use

```dart
...
yourFunction() async {
    print(await Camera.info);
}
```

## Example Use with Flutter

[Flutter demo repo](https://github.com/codetricity/theta_webapi_flutter_minimal)

![screenshot of flutter app](https://raw.githubusercontent.com/codetricity/theta_webapi_flutter_minimal/main/docs/images/android_demo.gif)