import 'package:flutter/services.dart';

class MethodChannelAudioCapture {
  static const MethodChannel _channel = MethodChannel('audio_capture');

  Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}