class QuizData {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizData(
      {required this.question,
      required this.options,
      required this.correctAnswer});
}