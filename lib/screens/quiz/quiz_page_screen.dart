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
  QuizData generateQuizData(Map<String, dynamic> args) {
    final vocabularies = List.from(args['vocabularies']);
    final random = Random();

    // Chọn ngẫu nhiên một câu hỏi
    final questionIndex = random.nextInt(vocabularies.length);
    final question = vocabularies[questionIndex];

    // Tạo danh sách đáp án
    List<String> options = [question['vietnameseWord']];
    vocabularies
      ..shuffle()
      ..remove(question);
    options.addAll(vocabularies.take(3).map((v) => v['vietnameseWord']));
    options.shuffle();

    return QuizData(
        question: question['englishWord'],
        options: options,
        correctAnswer: question['vietnameseWord']);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final amount = args['vocabularies'].length;
    final quizData = generateQuizData(args);

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
              // value: (currentIndex + 1) / flashcards.length,
              value: 1 / 2,
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
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: Text('Result'),
                      //       content: Text(
                      //         quizData.options[index] == quizData.correctAnswer
                      //             ? 'Correct Answer'
                      //             : 'Wrong Answer',
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: Text('OK'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                      showCustomDialog(context);
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

  void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.sentiment_dissatisfied, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Study this one!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        content: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Correct answer:\n',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'fero, ferre, tuli, latus\n\n',
                style: TextStyle(color: Colors.green),
              ),
              TextSpan(
                text: 'You said:\n',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: 'gero, gerere, gessi, gestus',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
