# Cross File Manager

![Cover - Cross File Manager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/cover.webp)

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/signmotion/id_gen/master/LICENSE)

Transparent reading of files from Flutter assets, Internet (by URL), zip archives by uploader priority.
The easy-to-use package.

## Features

We can choose with `CrossFileManager` the priority for uploaders yourself. For example, if the file is not in the assets, an attempt will be made to get the file from the cloud.

Can develop own loader for download files from Firebase, Firestore, Amazon AWS, Google Drive, Microsoft Azure Cloud Storage, OneDrive, Dropbox, etc. - any data source can be included in the CrossFileManager. See `class Loader` and [already implemented loaders](https://github.com/signmotion/cross_file_manager/tree/master/lib/src/loaders).

Can retrieve the needed file from an archive. It comes in handy when you need to download thousands of small files.

Can memorize a received file and retrieve it from local storage the next time it is requested.

Able to download files in formats:

- `String`
- `Image` like `dart.ui`
- `Image` like `package:flutter/widgets.dart`
- `File`, binary data

### How it works

![Direct path to file - CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/request_response.webp)

## Getting started

Add this package to `pubspec.yaml`. See `Installing` tab above.

## Usage

Create a manager for App:

```dart
final fm = CrossFileManager.create(
  loaders: const [
    PlainAssetsLoader(),
    ZipAssetsLoader(),
    PlainFileLoader(),
    ZipFileLoader(),
  ],
);
```

Use the manager in the App:

```dart
final String? r = await fm.loadString(path);
```

```dart
import 'dart:ui' as ui;

final ui.Image? r = await fm.loadImageUi(path);
```

```dart
import 'package:flutter/widgets.dart' as widgets;

final widgets.Image? r = await fm.loadImageWidget(path);
```

```dart
final File? r = await fm.loadFile(path);
```

```dart
final bool r = await fm.exists(path);
```

```dart
final bool r = await fm.existsInCache(path);
```

```dart
/// Just add file to cache for fast access in the future.
await fm.warmUp(path);
```

The manager announced above will search file by `path` in the local assets,
then in the zip archives of local assets,
then in the local filesystem,
then in the zip archives of local filesystem.

It will return the first file found.

See `example/main.dart` for more use cases:

[![Example App with CrossFileManager](https://raw.githubusercontent.com/signmotion/cross_file_manager/master/images/zip_assets_demo.webp)](https://github.com/signmotion/cross_file_manager/tree/master/example)

## Welcome

This package is open-source, stable and well-tested. Development happens on
[GitHub](https://github.com/signmotion/cross_file_manager). Feel free to report issues
or create a pull-request there.

General questions are best asked on
[StackOverflow](https://stackoverflow.com/questions/tagged/cross_file_manager).

## TODO

- Separate the package to work with pure Dart.
- Replace `File` to `WFile`. <https://pub.dev/packages/wfile>
