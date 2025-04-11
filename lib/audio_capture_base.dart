import 'dart:ffi';
import 'dart:io';

import 'package:audio_capture/src/audio_capture_bindings.dart';
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

class AudioCaptureBase {

  static audio_capture_bindings? _bindings;
  static bool _isInitialized = false;

  /// Initializes the audio capture system
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    _loadBindings();

    if (_bindings == null) {
      print('Failed to load audio capture library');
      return false;
    }

    // Initialize audio capture through FFI
    bool success = await _initializeAudioCapture();
    if (success) {
      _isInitialized = true;
    }
    print('_isInitialized: $_isInitialized');

    return _isInitialized;
  }

  /// Starts capturing audio from the current application
  static bool startCapture() {
    if (!_isInitialized || _bindings == null) {
      return false;
    }

    bool success = _startAudioCapture();
    print('_startAudioCapture: $success');

    return success;
  }

  /// Stops capturing audio
  static void stopCapture() {
    if (!_isInitialized || _bindings == null) {
      return;
    }

    _stopAudioCapture();
  }

  /// Gets captured audio data
  ///
  /// Returns a list of audio samples if successful, or an empty list if failed
  static List<double> getAudioData(int bufferSize) {
    if (!_isInitialized || _bindings == null || bufferSize <= 0) {
      print('getAudioData: []');

      return [];
    }

    final buffer = calloc<Float>(bufferSize);
    try {
      bool success = _getAudioData(buffer, bufferSize);
      if (!success) {
        print('_getAudioData: unsuccess');

        return [];
      }

      // Convert FFI buffer to Dart list
      final result = List<double>.filled(bufferSize, 0.0);
      for (int i = 0; i < bufferSize; i++) {
        result[i] = buffer[i];
      }

      return result;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Gets audio format information
  ///
  /// Returns a tuple containing [sampleRate, channels]
  static List<int> getAudioFormat() {
    if (!_isInitialized || _bindings == null) {
      return [44100, 2]; // Default values
    }

    final sampleRate = calloc<Int>();
    final channels = calloc<Int>();

    try {
      _getAudioFormat(sampleRate, channels);
      print('getAudioFormat: ${sampleRate.value}  ${channels.value}');

      return [sampleRate.value, channels.value];
    } finally {
      calloc.free(sampleRate);
      calloc.free(channels);
    }
  }

  /// Cleans up resources
  static void cleanup() {
    if (!_isInitialized || _bindings == null) {
      return;
    }

    _cleanupAudioCapture();
    _isInitialized = false;
  }

  // Private methods that call the FFI bindings

  static void _loadBindings() {
    if (_bindings != null) return;

    try {
      DynamicLibrary library;
      if (Platform.isWindows) {
        String exeDirectory = File(Platform.resolvedExecutable).parent.path;
        String dllPath = path.join(exeDirectory,'audio_capture.dll');
        print('Trying to load DLL from: $dllPath');

        library = DynamicLibrary.open(dllPath);
        print('DLL Loaded Successfully!');
      } else if (Platform.isMacOS) {
        library = DynamicLibrary.open('audio_capture.dylib');
      } else if (Platform.isLinux || Platform.isAndroid) {
        library = DynamicLibrary.open('audio_capture.so');
      } else {
        throw UnsupportedError(
            'Unsupported platform: ${Platform.operatingSystem}\r\n');
      }

      _bindings = audio_capture_bindings(library);
    } catch (e) {
      print('Failed to load audio capture library: $e');
      print('Current Directory: ${Directory.current.path}');
      _bindings = null;
    }
  }

  // Direct FFI function calls

  static Future<bool> _initializeAudioCapture() async {
    if (_bindings == null) return false;

    try {
      return _bindings?.InitializeAudioCapture(nullptr) ?? false;
    } catch (e) {
      print('Failed to initialize audio capture: $e');
      return false;
    }
  }

  static bool _startAudioCapture() {
    if (_bindings == null) return false;

    try {
      return _bindings?.StartAudioCapture() ?? false;
    } catch (e) {
      print('Failed to start audio capture: $e');
      return false;
    }
  }

  static void _stopAudioCapture() {
    if (_bindings == null) return;

    try {
      _bindings?.StopAudioCapture();
    } catch (e) {
      print('Failed to stop audio capture: $e');
    }
  }

  static bool _getAudioData(Pointer<Float> buffer, int bufferSize) {
    if (_bindings == null) return false;

    try {
      return _bindings?.GetAudioData(buffer, bufferSize) ?? false;
    } catch (e) {
      print('Failed to get audio data: $e');
      return false;
    }
  }

  static void _getAudioFormat(Pointer<Int> sampleRate, Pointer<Int> channels) {
    if (_bindings == null) return;

    try {
      _bindings?.GetAudioFormat(sampleRate, channels);
    } catch (e) {
      print('Failed to get audio format: $e');
    }
  }

  static void _cleanupAudioCapture() {
    if (_bindings == null) return;

    try {
      _bindings?.CleanupAudioCapture();
    } catch (e) {
      print('Failed to clean up audio capture: $e');
    }
  }
}
