import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CreateTerm extends StatefulWidget {
  const CreateTerm(this.text);

  final String text;

  @override
  State<CreateTerm> createState() => _CreateTermState();
}

class _CreateTermState extends State<CreateTerm> {
  late FlutterTts flutterTts;
  bool isFavorite = false;
  bool isVolumeOn = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  Future<void> _speak(String text) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text).then((_) {
      if (mounted) {
        setState(() {
          isVolumeOn = false; // Cập nhật trạng thái khi hoàn thành đọc
        });
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isVolumeOn = !isVolumeOn;
                if (isVolumeOn) {
                  _speak(widget.text);
                } else {
                  flutterTts.stop();
                }
              });
            },
            child: Container(
              margin: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite; // Toggle the favorite icon state
                });
              },
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 55,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isVolumeOn = !isVolumeOn; // Toggle the volume icon state
                  if (isVolumeOn) {
                    _speak(widget.text); // Speak when the volume is on
                  } else {
                    flutterTts.stop(); // Stop speaking when the volume is off
                  }
                });
              },
              child: Icon(
                isVolumeOn
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
