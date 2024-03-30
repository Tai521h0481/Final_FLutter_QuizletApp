import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shop_app/models/QuizData.dart';
import 'package:shop_app/screens/quiz/components/quiz_option.dart';

class QuizPage extends StatefulWidget {
  static String routeName = "quiz_page";

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final audioPlayer = AudioPlayer();
  int currentQuestionIndex = 0;
  List<QuizData> allQuizData = [];
  Set<int> usedQuestionIndices = {};

  QuizData generateQuizData(Map<String, dynamic> args) {
    final vocabularies = List.from(args['vocabularies']);
    final random = Random();
    int questionIndex;

    do {
      questionIndex = random.nextInt(vocabularies.length);
    } while (usedQuestionIndices.contains(questionIndex));

    usedQuestionIndices.add(questionIndex);

    final question = vocabularies[questionIndex];

    List<String> options = [question['vietnameseWord']];
    vocabularies.shuffle();
    options.addAll(vocabularies.where((v) => v['vietnameseWord'] != question['vietnameseWord']).take(3).map((v) => v['vietnameseWord']));
    options.shuffle();

    return QuizData(
      question: question['englishWord'],
      options: options,
      correctAnswer: question['vietnameseWord'],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (allQuizData.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      allQuizData = List.generate(
          args['vocabularies'].length, (_) => generateQuizData(args));
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < allQuizData.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Navigate to the home screen or the desired screen when quiz is finished.
      // Navigator.pushNamed(context, homeRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizData = allQuizData[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.indigo.shade700,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.indigo.shade500),
                      )),
                  Text(
                    'Live Quiz',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person_pin_rounded,
                      color: Colors.pinkAccent.shade100,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue.shade300),
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/image5.png',
              ),
            ),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / allQuizData.length,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    quizData.question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                itemCount: quizData.options.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 4),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return QuizOption(
                    text: quizData.options[index],
                    color: Colors.indigo.shade500,
                    onTap: () {
                      if (quizData.options[index] == quizData.correctAnswer) {
                        correctDialog(context, quizData.correctAnswer);
                      } else {
                        wrongDialog(context, quizData.question,
                            quizData.options[index], quizData.correctAnswer);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> correctDialog(BuildContext context, String answer) async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('😃'),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "You got it this time!",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          content: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: answer,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
              ],
            ),
          ),
        );
      },
    );
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    await audioPlayer.stop();
    goToNextQuestion();
  }

  Future<void> wrongDialog(BuildContext context, String question,
      String selectedAnswer, String correctAnswer) async {
    await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('😕'),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Study this one!",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          content: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: question + "\n\n",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
                TextSpan(
                  text: 'Correct answer:\n',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: correctAnswer + "\n\n",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
                TextSpan(
                  text: 'You said:\n',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: selectedAnswer,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                      fontSize: 25),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                goToNextQuestion();
              },
            ),
          ],
        );
      },
    );
  }
}
