import '../utils/html_unescape_helper.dart';

class QuizQuestion {
  final String category;
  final String type; // 'multiple' or 'boolean'
  final String difficulty;
  final String question;
  final String correctAnswer;
  List<String> correctAnswers;
  final List<String> incorrectAnswers;
  final List<String> shuffledAnswers;

  String? selectedAnswer;
  List<String> selectedAnswers = [];
  bool isTimedOut;
  bool isSubmitted;

  QuizQuestion({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    List<String>? correctAnswers,
    required this.incorrectAnswers,
    required this.shuffledAnswers,
    this.selectedAnswer,
    this.isTimedOut = false,
    this.isSubmitted = false,
  }) : correctAnswers = correctAnswers ?? [correctAnswer];

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['category'] as String? ?? '';
    final rawType = json['type'] as String? ?? 'multiple';
    final rawDifficulty = json['difficulty'] as String? ?? 'easy';
    final rawQuestion = json['question'] as String? ?? '';
    final rawCorrect = json['correct_answer'] as String? ?? '';
    final rawIncorrectList = (json['incorrect_answers'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final decodedCategory = HtmlUnescapeHelper.unescape(rawCategory);
    final decodedQuestion = HtmlUnescapeHelper.unescape(rawQuestion);
    final decodedCorrect = HtmlUnescapeHelper.unescape(rawCorrect);
    final decodedIncorrect = rawIncorrectList
        .map((ans) => HtmlUnescapeHelper.unescape(ans))
        .toList();

    final List<String> answers = [decodedCorrect, ...decodedIncorrect];
    if (rawType == 'boolean') {
      answers.sort((a, b) => b.compareTo(a));
    } else {
      answers.shuffle();
    }

    return QuizQuestion(
      category: decodedCategory,
      type: rawType,
      difficulty: rawDifficulty,
      question: decodedQuestion,
      correctAnswer: decodedCorrect,
      incorrectAnswers: decodedIncorrect,
      correctAnswers: [decodedCorrect],
      shuffledAnswers: answers,
    );
  }

  bool get isAnswered => isSubmitted || isTimedOut;

  bool get isCorrect {
    if (selectedAnswers.isNotEmpty) {
      final selectedSet = selectedAnswers.toSet();
      final correctSet = correctAnswers.toSet();
      return selectedSet.length == correctSet.length &&
          selectedSet.containsAll(correctSet);
    }

    return selectedAnswer != null && correctAnswers.contains(selectedAnswer);
  }

  bool get hasMultipleCorrectAnswers => correctAnswers.length > 1;
}
