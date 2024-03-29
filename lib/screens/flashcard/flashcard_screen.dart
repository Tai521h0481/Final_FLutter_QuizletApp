import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/flashcard/components/congrats_screen.dart';

class FlashcardsView extends StatefulWidget {
  static String routeName = '/flashcards';
  @override
  _FlashcardsViewState createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> {
  late FlutterTts flutterTts;
  // final List<Map<String, String>> flashcards = [
  //   {'englishWord': 'Cat', 'vietnameseWord': 'Con mèo'},
  //   {'englishWord': 'Dog', 'vietnameseWord': 'Con chó'},
  //   {'englishWord': 'Bird', 'vietnameseWord': 'Con chim'},
  //   // ... include all your flashcards here
  // ];
  int currentIndex = 0;
  bool showFront = true;
  Offset cardPosition = Offset.zero;
  double cardRotation = 0.0;
  bool _autoplayInProgress = false;
  bool isVolumeOn = false;
  FlipCardController controllerFlipCard = FlipCardController();
  late String topicId;
  // List<Map<String, String>> flashcards = [];
  List<dynamic> flashcards = [];
  late String token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  void _loadInitialData() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey("topicId")) {
      topicId = args["topicId"];
      _loadTopics();
    } else {
      print('Invalid arguments. Cannot load topics.');
    }
  }

  Future<void> _loadTopics() async {
    token = (await SharedPreferences.getInstance()).getString('token') ?? '';
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }
    try {
      await getVocabularyByTopicId(topicId, token)
          .then((value) => flashcards = value['vocabularies']);
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _nextCard() {
    if (!showFront) controllerFlipCard.toggleCardWithoutAnimation();
    if (currentIndex + 1 == flashcards.length) {
      Navigator.pushNamed(context, CongratsScreen.routeName);
    }
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showFront = true;
      cardPosition = Offset.zero;
      cardRotation = 0.0;
    });
  }

  void _previousCard() {
    if (!showFront) controllerFlipCard.toggleCardWithoutAnimation();
    setState(() {
      currentIndex = (currentIndex - 1 + flashcards.length) % flashcards.length;
      showFront = true;
      cardPosition = Offset.zero;
      cardRotation = 0.0;
    });
  }

  Future<void> _speak(String text, bool isEn) async {
    await flutterTts.setLanguage(isEn ? "en-US" : "vi-VN");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text).then((_) {
      if (mounted) {
        setState(() {
          isVolumeOn = false;
        });
      }
    });
  }

  Future<void> _startAutoplay() async {
    if (currentIndex + 1 == flashcards.length) {
      setState(() {
        currentIndex = 0;
        controllerFlipCard.toggleCardWithoutAnimation();
      });
    }
    if (_autoplayInProgress) return;
    _autoplayInProgress = true;

    while (_autoplayInProgress && currentIndex < flashcards.length) {
      await _speak(flashcards[currentIndex]['englishWord']!, true);

      await Future.delayed(Duration(milliseconds: 500));

      controllerFlipCard.toggleCard();
      setState(() {
        showFront = false;
      });

      await Future.delayed(Duration(milliseconds: 500));

      await _speak(flashcards[currentIndex]['vietnameseWord']!, false);

      await Future.delayed(Duration(milliseconds: 500));

      await Future.delayed(Duration(milliseconds: 500));
      if (currentIndex + 1 < flashcards.length) {
        _nextCard();
      } else {
        setState(() {
          _autoplayInProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: Text(
          '${currentIndex + 1}/${flashcards.length}',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 3),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LinearProgressIndicator(
            value: (currentIndex + 1) / flashcards.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) => _onDragUpdate(context, details),
              onPanEnd: (details) => _onDragEnd(context, details),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 320,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: cardPosition,
                    child: Transform.rotate(
                      angle: cardRotation,
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        onFlip: () => _flipCard(),
                        front: buildFlashCard(
                            flashcards[currentIndex]['englishWord']!, true),
                        back: buildFlashCard(
                            flashcards[currentIndex]['vietnameseWord']!, false),
                        controller: controllerFlipCard,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: currentIndex > 0 ? _previousCard : null,
              ),
              IconButton(
                icon: Icon(_autoplayInProgress
                    ? Icons.pause_circle
                    : Icons.play_arrow_rounded),
                onPressed: _autoplayInProgress ? _stopAutoplay : _startAutoplay,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  void _stopAutoplay() {
    _autoplayInProgress = false;
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails details) {
    setState(() {
      cardPosition += details.delta;
      cardRotation = cardPosition.dx * 0.001;
    });
  }

  void _onDragEnd(BuildContext context, DragEndDetails details) {
    final double velocityThreshold = 100.0;
    if (details.velocity.pixelsPerSecond.distance > velocityThreshold) {
      _nextCard();
    } else {
      setState(() {
        cardPosition = Offset.zero;
        cardRotation = 0.0;
      });
    }
  }

  void _flipCard() {
    setState(() {
      showFront = !showFront;
    });
    print("showFront: $showFront");
  }

  Widget buildFlashCard(String text, bool isFront) {
    return Container(
      width: 320,
      height: 500,
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: cardPosition.distance == 0 ? Colors.transparent : Colors.blue,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              icon:
                  Icon(Icons.volume_up_outlined, size: 23, color: Colors.black),
              onPressed: () {
                _speak(text, isFront);
                setState(() {
                  isVolumeOn = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
