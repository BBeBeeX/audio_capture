import 'dart:async';

import 'audio_capture_base.dart';

/// Captures audio output from the current application.
///
/// This class provides a high-level API for capturing and processing
/// audio output from the current application (system audio).
class AudioCapture {
  bool _isCapturing = false;
  final int _bufferSize;
  Timer? _captureTimer;

  /// The interval at which audio data is captured, in milliseconds.
  final int captureInterval;

  /// Stream controller for the audio data.
  final StreamController<List<double>> _audioStreamController =
      StreamController<List<double>>.broadcast();

  /// Stream of audio data samples.
  Stream<List<double>> get audioStream => _audioStreamController.stream;

  /// Whether audio is currently being captured.
  bool get isCapturing => _isCapturing;

  /// The audio sample rate (e.g., 44100 Hz).
  int get sampleRate => _audioFormat[0];

  /// The number of audio channels (e.g., 2 for stereo).
  int get channels => _audioFormat[1];

  /// Audio format information [sampleRate, channels].
  List<int> _audioFormat = [44100, 2];

  /// Creates a new [AudioCapture] instance.
  ///
  /// [bufferSize] specifies how many audio samples to capture at once.
  /// [captureInterval] specifies how often to capture audio data, in milliseconds.
  AudioCapture({
    int bufferSize = 2048,
    this.captureInterval = 50,
  }) : _bufferSize = bufferSize {}

  Future<void> init()async{
    await AudioCaptureBase.initialize();
    _audioFormat = AudioCaptureBase.getAudioFormat();
  }

  /// Starts capturing audio from the current application.
  ///
  /// Returns true if capture started successfully, false otherwise.
  bool start() {
    if (_isCapturing) return true;

    final success = AudioCaptureBase.startCapture();
    if (success) {
      _isCapturing = true;
      _startCaptureTimer();
    }

    return success;
  }

  /// Stops capturing audio.
  void stop() {
    if (!_isCapturing) return;

    _captureTimer?.cancel();
    _captureTimer = null;
    AudioCaptureBase.stopCapture();
    _isCapturing = false;
  }

  /// Disposes resources.
  void dispose() {
    stop();
    AudioCaptureBase.cleanup();
    _audioStreamController.close();
  }


  void _startCaptureTimer() {
    _captureTimer?.cancel();
    _captureTimer = Timer.periodic(Duration(milliseconds: captureInterval), (_) {
      final audioData = AudioCaptureBase.getAudioData(_bufferSize);
      if (audioData.isNotEmpty) {
        print(audioData);
        _audioStreamController.add(audioData);
      }
    });
  }
}
