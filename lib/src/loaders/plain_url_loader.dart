import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;

import 'loader.dart';

/// The loader for load and trasform data from Internet by URL.
class PlainUrlLoader extends Loader {
  const PlainUrlLoader({required this.base}) : assert(base.length > 0);

  final String base;

  String url(String path) => p.join(base, path);

  @override
  Future<bool> exists(String path) async {
    assert(path.isNotEmpty);

    late final File? file;
    try {
      file = await loadFile(path);
    } on Exception {
      // it's OK: a state can be 404 or any
      log("$runtimeType exists() doesn't found `$path`");
      file = null;
    }

    return file?.existsSync() ?? false;
  }

  @override
  Future<File?> loadFile(String path) async {
    assert(path.isNotEmpty);

    CacheManager.logLevel = kDebugMode
        ? CacheManagerLogLevel.verbose
        : CacheManagerLogLevel.warning;

    /* \todo Add `loadFileStream()`.
    cacheManager.getFileStream(
      pathWithBase(path),
      withProgress: true,
    );
    */

    try {
      return (await cacheManager.downloadFile(url(path))).file;
    } on Exception {
      // it's OK: a state can be 404 or any
      log("$runtimeType loadFile() doesn't load `$path`");
    }

    return null;
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

    final file = await loadFile(path);

    return file == null
        ? null
        : widgets.Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: errorBuilder,
          );
  }

  @override
  Future<String?> loadString(String path) async {
    assert(path.isNotEmpty);

    final file = await loadFile(path);

    return file?.readAsStringSync();
  }
}
