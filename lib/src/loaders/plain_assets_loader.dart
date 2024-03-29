import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' as widgets;
import 'package:path/path.dart' as pp;

import 'loader.dart';

/// The loader for load and trasform data from plain assets.
class PlainAssetsLoader extends Loader {
  const PlainAssetsLoader();

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    if (await notExists(path)) {
      return null;
    }

    final bytes = await rootBundle.load(path);

    final pathToFile = pp.join(await localPath, path);
    final file = File(pathToFile);
    final prepared =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    final dir = pp.dirname(pathToFile);
    Directory(dir).createSync(recursive: true);
    await file.writeAsBytes(prepared);

    return file;
  }

  @override
  Future<widgets.Image?> loadImageWidget(
    String path, {
    double? width,
    double? height,
    widgets.BoxFit? fit,
    widgets.ImageErrorWidgetBuilder? errorBuilder,
  }) async {
    assert(path.isNotEmpty);

    return await exists(path)
        ? widgets.Image.asset(
            path,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: errorBuilder,
          )
        : null;
  }

  @override
  Future<String?> loadString(String path) async {
    assert(path.isNotEmpty);

    return await exists(path) ? rootBundle.loadString(path) : null;
  }
}
