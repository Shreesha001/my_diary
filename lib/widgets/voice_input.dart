import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInput extends StatefulWidget {
  final Function(String) onTextRecognized;

  const VoiceInput({super.key, required this.onTextRecognized});

  @override
  State<VoiceInput> createState() => _VoiceInputState();
}

class _VoiceInputState extends State<VoiceInput> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        _startListening();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Speech recognition not available")),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Microphone permission denied")));
    }
  }

  void _startListening() {
    setState(() => _isListening = true);
    _speech.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
      listenMode: stt.ListenMode.confirmation,
      localeId: 'en_US', // You can change locale if needed
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1C2F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Voice Input"),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Text(
                _recognizedText.isEmpty ? "Start speaking..." : _recognizedText,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.pinkAccent,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onTextRecognized(_recognizedText);
                    Navigator.pop(context);
                  },
                  child: Text("Done"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
