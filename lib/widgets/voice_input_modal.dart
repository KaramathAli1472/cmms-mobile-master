import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputModal extends StatefulWidget {
  final String localeId;

  const VoiceInputModal({super.key, this.localeId = 'en_IN'});

  @override
  State<VoiceInputModal> createState() => _VoiceInputModalState();
}

class _VoiceInputModalState extends State<VoiceInputModal> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  String _finalRecognizedText = '';
  double _micOpacity = 1.0;
  Timer? _blinkTimer;
  Timer? _timer;
  int _elapsed = 0; // seconds

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  void _startRecording() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _recognizedText = '';
        _finalRecognizedText = '';
        _elapsed = 0;
      });
      _startBlinking();
      _startTimer();
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
          // Always save the last final result
          if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
            _finalRecognizedText = result.recognizedWords.trim();
          }
        },
        onSoundLevelChange: null,
        localeId: widget.localeId,
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
        ),
      );
      _speechToText.statusListener = (status) async {
        if (status == "notListening" && _isListening) {
          _stopRecording();
          await Future.delayed(const Duration(milliseconds: 700));
          String textToReturn = _finalRecognizedText.isNotEmpty
              ? _finalRecognizedText
              : _recognizedText.trim();
          Navigator.pop(context, textToReturn);
        }
      };
      ;
    } else {
      Navigator.pop(context);
    }
  }

  void _startBlinking() {
    _blinkTimer?.cancel();
    _micOpacity = 1.0;
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _micOpacity = _micOpacity == 1.0 ? 0.3 : 1.0;
      });
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed += 1;
      });
    });
  }

  void _stopBlinking() {
    _blinkTimer?.cancel();
    setState(() {
      _micOpacity = 1.0;
    });
  }

  void _stopRecording() {
    _speechToText.stop();
    setState(() => _isListening = false);
    _stopBlinking();
    _timer?.cancel();
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _timer?.cancel();
    _speechToText.stop();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(24),
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isListening ? _micOpacity : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(Icons.mic, color: Colors.red, size: 64),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDuration(_elapsed),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              width: double.infinity,
              child: Text(
                _recognizedText.isEmpty ? 'Listening...' : _recognizedText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.cancel, color: Colors.grey),
                  label: const Text('Cancel'),
                  onPressed: () {
                    _stopRecording();
                    Navigator.pop(context); // Do nothing
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop, color: Colors.white),
                  label: const Text('Stop & Use Text'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    _stopRecording();
                    await Future.delayed(const Duration(milliseconds: 700));
                    String textToReturn = _finalRecognizedText.isNotEmpty
                        ? _finalRecognizedText
                        : _recognizedText.trim();
                    Navigator.pop(context, textToReturn);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
