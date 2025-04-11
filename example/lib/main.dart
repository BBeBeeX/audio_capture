import 'dart:async';
import 'dart:math';

import 'package:audio_capture/audio_capture.dart';
import 'package:fftea/impl.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Capture Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AudioCaptureExample(),
    );
  }
}

class AudioCaptureExample extends StatefulWidget {
  const AudioCaptureExample({super.key});

  @override
  State<AudioCaptureExample> createState() => _AudioCaptureExampleState();
}

// Enum for different visualization types
enum VisualizationType {
  waveform,
  bars,
  fft,
  spectrum,
}

class _AudioCaptureExampleState extends State<AudioCaptureExample> with SingleTickerProviderStateMixin {
  late AudioCapture _audioCapture;
  bool _isCapturing = false;
  List<double> _audioData = [];
  StreamSubscription<List<double>>? _audioStreamSubscription;
  final AudioPlayer _player = AudioPlayer();

  // Tab controller for visualizations
  late TabController _tabController;
  final List<VisualizationType> _visualizationTypes = VisualizationType.values;

  @override
  void initState() {
    super.initState();
    _initializeAudioCapture();
    JustAudioMediaKit.ensureInitialized();
    _player.setAudioSource(AudioSource.uri(Uri.parse(
        'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3')));
    _player.play();

    // Initialize tab controller
    _tabController = TabController(
      length: _visualizationTypes.length,
      vsync: this
    );
  }

  void _initializeAudioCapture() {
    // Create an instance of AppAudioCapture with a buffer size of 1024
    _audioCapture = AudioCapture(bufferSize: 1024);
  }

  void _startCapture() {
    if (_audioCapture.start()) {
      setState(() {
        _isCapturing = _audioCapture.start();
      });

      // Subscribe to the audio stream
      _audioStreamSubscription = _audioCapture.audioStream.listen((audioData) {
        setState(() {

          // final freq = FFT(audioData.length).realFft(audioData);
          // _audioData = List.generate(freq.length, (i) {
          //   final real = freq[i].x;
          //   final imag = freq[i].y;
          //   return sqrt(real * real + imag * imag);
          // });
          _audioData = audioData;
        });
      });
    }
  }

  void _stopCapture() {
    _audioStreamSubscription?.cancel();
    _audioStreamSubscription = null;
    _audioCapture.stop();
    setState(() {
      _isCapturing = false;
    });
  }

  @override
  void dispose() {
    _stopCapture();
    _audioCapture.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Capture Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Waveform'),
            Tab(text: 'Bars'),
            Tab(text: 'FFT'),
            Tab(text: 'Spectrum'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButtons(_player),
            Text(
              'Sample Rate: ${_audioCapture.sampleRate} Hz',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Channels: ${_audioCapture.channels}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCapturing ? _stopCapture : _startCapture,
              child: Text(_isCapturing ? 'Stop Capture' : 'Start Capture'),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: _isCapturing
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        AudioWaveformDisplay(audioData: _audioData, type: VisualizationType.waveform),
                        AudioWaveformDisplay(audioData: _audioData, type: VisualizationType.bars),
                        AudioWaveformDisplay(audioData: _audioData, type: VisualizationType.fft),
                        AudioWaveformDisplay(audioData: _audioData, type: VisualizationType.spectrum),
                      ],
                    )
                  : const Center(
                      child: Text('Press Start Capture to begin'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioWaveformDisplay extends StatelessWidget {
  final List<double> audioData;
  final VisualizationType type;

  const AudioWaveformDisplay({
    super.key,
    required this.audioData,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AudioWaveformPainter(audioData, type),
      size: Size.infinite,
    );
  }
}

class AudioWaveformPainter extends CustomPainter {
  final List<double> audioData;
  final VisualizationType type;

  AudioWaveformPainter(this.audioData, this.type);

  @override
  void paint(Canvas canvas, Size size) {
    if (audioData.isEmpty) return;

    switch (type) {
      case VisualizationType.waveform:
        _paintWaveform(canvas, size);
        break;
      case VisualizationType.bars:
        _paintBars(canvas, size);
        break;
      case VisualizationType.fft:
        _paintFFT(canvas, size);
        break;
      case VisualizationType.spectrum:
        _paintSpectrum(canvas, size);
        break;
    }
  }

  void _paintWaveform(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;
    final step = width / (audioData.length - 1);

    // Draw the waveform
    path.moveTo(0, centerY + audioData[0] * centerY * 0.8);
    for (int i = 1; i < audioData.length; i++) {
      path.lineTo(i * step, centerY + audioData[i] * centerY * 0.8);
    }

    canvas.drawPath(path, paint);
  }

  void _paintBars(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    // Calculate number of bars to display
    final barCount = min(audioData.length, 64);
    final barWidth = width / barCount - 2;

    // Group samples to fit the number of bars
    final samplesPerBar = audioData.length ~/ barCount;

    for (int i = 0; i < barCount; i++) {
      // Calculate average amplitude for this bar
      double sum = 0;
      int count = 0;
      for (int j = 0; j < samplesPerBar; j++) {
        int index = i * samplesPerBar + j;
        if (index < audioData.length) {
          sum += audioData[index].abs();
          count++;
        }
      }

      final amplitude = count > 0 ? sum / count : 0;
      final barHeight = amplitude * centerY * 1.5;

      // Draw the bar
      final left = i * (barWidth + 2);
      final right = left + barWidth;

      canvas.drawRect(
        Rect.fromLTRB(
          left,
          centerY - barHeight,
          right,
          centerY + barHeight
        ),
        paint,
      );
    }
  }

  void _paintFFT(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    // Simple FFT-like visualization (approximation)
    // For real FFT, you would need to implement FFT algorithm or use a library

    // We'll create a frequency-domain-like visualization
    final barCount = min(audioData.length ~/ 2, 64);
    final barWidth = width / barCount - 2;

    // In a real FFT, we would do the Fourier transform here
    List<double> fftData = _simulateFFT(audioData, barCount);

    for (int i = 0; i < barCount; i++) {
      // The height increases with frequency to simulate FFT output
      final magnitude = fftData[i];
      final barHeight = magnitude * height * 0.8;

      final left = i * (barWidth + 2);
      final right = left + barWidth;

      canvas.drawRect(
        Rect.fromLTRB(
          left,
          height - barHeight,
          right,
          height
        ),
        paint,
      );
    }
  }

  // This is a simplified simulation of FFT output
  // In production, you would use a real FFT algorithm
  List<double> _simulateFFT(List<double> timeData, int bins) {
    List<double> result = List<double>.filled(bins, 0);

    // Simple approximation - in real FFT this would be frequency components
    for (int i = 0; i < bins; i++) {
      // Calculate a weighted sum of samples at different offsets
      double sum = 0;
      int count = 0;

      // For each bin, we sample from different parts of the signal
      // Higher frequency bins sample more from the beginning of the signal
      int samplesPerBin = timeData.length ~/ bins;
      int offset = (i * samplesPerBin) ~/ 2;

      for (int j = 0; j < samplesPerBin; j++) {
        int index = (offset + j) % timeData.length;
        sum += timeData[index].abs();
        count++;
      }

      // Add some randomness to make it look more like frequency spectrum
      double average = count > 0 ? sum / count : 0;

      // Higher frequencies typically have lower amplitude
      result[i] = average * (1.0 - (i / bins) * 0.5);

      // Add some randomness to make it look more dynamic
      result[i] *= 0.5 + Random().nextDouble() * 0.5;
    }

    return result;
  }

  void _paintSpectrum(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Create frequency-domain data similar to FFT
    final barCount = min(audioData.length ~/ 2, 128);
    final barWidth = width / barCount;

    // Simulate FFT data
    List<double> spectrumData = _simulateFFT(audioData, barCount);

    // Draw each frequency bin with a color gradient
    for (int i = 0; i < barCount; i++) {
      final magnitude = spectrumData[i];
      final barHeight = magnitude * height * 0.9;

      // Create a gradient color based on frequency
      // Lower frequencies are red/orange, higher frequencies are blue/purple
      final hue = 240 - (240 * i / barCount); // From blue (240) to red (0)
      final saturation = 0.8;
      final value = 0.9;

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HSVColor.fromAHSV(1.0, hue, saturation, value).toColor(),
            HSVColor.fromAHSV(1.0, hue, saturation, value * 0.5).toColor(),
          ],
        ).createShader(Rect.fromLTWH(0, height - barHeight, barWidth, barHeight));

      final left = i * barWidth;

      // Draw rectangle for each frequency bin
      canvas.drawRect(
        Rect.fromLTWH(
          left,
          height - barHeight,
          barWidth - 1, // Small gap between bars
          barHeight
        ),
        paint,
      );

      // Add a highlight at the top of each bar
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(left, height - barHeight),
        Offset(left + barWidth - 1, height - barHeight),
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(AudioWaveformPainter oldDelegate) {
    return oldDelegate.audioData != audioData || oldDelegate.type != type;
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {},
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
