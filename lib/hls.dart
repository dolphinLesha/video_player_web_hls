@JS()
library hls.js;

import 'dart:html';

import 'package:js/js.dart';

@JS('Hls.isSupported')
external bool isSupported();

@JS()
class Hls {
  external factory Hls(HlsConfig config);

  @JS()
  external void startLoad();

  @JS()
  external void stopLoad();

  @JS()
  external void recoverMediaError();

  @JS()
  external void destroy();

  @JS()
  external void loadSource(String videoSrc);

  @JS()
  external void attachMedia(VideoElement video);

  @JS()
  external void on(String event, Function callback);

  external HlsConfig config;
}

@JS()
@anonymous
class HlsConfig {
  @JS()
  external Function get xhrSetup;

  external factory HlsConfig({
    Function xhrSetup,
    bool debug,
    int appendErrorMaxRetry,
    String defaultAudioCodec,
    int initialLiveManifestSize,
    bool liveDurationInfinity,
  });
}

class ErrorData {
  late final String type;
  late final String details;
  late final bool fatal;

  ErrorData(dynamic errorData) {
    type = errorData.type as String;
    details = errorData.details as String;
    fatal = errorData.fatal as bool;
  }
}
