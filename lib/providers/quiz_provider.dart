import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/quiz_config.dart';
import '../models/quiz_question.dart';
import '../services/api_service.dart';
import '../services/preferences_service.dart';

class QuizProvider extends ChangeNotifier {
  final ApiService _apiService;

  QuizProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  QuizConfig? _currentConfig;
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isQuizCompleted = false;

  int _questionDurationSeconds = 20;
  int _remainingSeconds = 20;
  Timer? _timer;

  final Stopwatch _sessionStopwatch = Stopwatch();
  int _totalElapsedSeconds = 0;

  QuizConfig? get currentConfig => _currentConfig;
  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get score => _score;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isQuizCompleted => _isQuizCompleted;
  int get remainingSeconds => _remainingSeconds;
  int get questionDurationSeconds => _questionDurationSeconds;
  int get totalElapsedSeconds => _totalElapsedSeconds;

  QuizQuestion? get currentQuestion =>
      (_questions.isNotEmpty && _currentIndex < _questions.length)
          ? _questions[_currentIndex]
          : null;

  double get progress =>
      totalQuestions > 0 ? (_currentIndex + 1) / totalQuestions : 0.0;

  double get accuracyPercentage =>
      totalQuestions > 0 ? ((_score / totalQuestions) * 100) : 0.0;

  Future<void> startQuiz(QuizConfig config) async {
    _currentConfig = config;
    _questionDurationSeconds = config.timerDurationSeconds;
    _isLoading = true;
    _errorMessage = null;
    _isQuizCompleted = false;
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _cancelTimer();
    _sessionStopwatch.reset();
    notifyListeners();

    await PreferencesService.saveConfig(
      amount: config.amount,
      difficulty: config.difficulty,
      type: config.type,
      timerDurationSeconds: config.timerDurationSeconds,
      categoryId: config.category.id,
    );

    try {
      final fetchedQuestions = await _apiService.fetchQuestions(config);
      _questions = fetchedQuestions;
      if (config.type == 'multiple_selection') {
        _convertToMultipleSelection();
      }
      _isLoading = false;
      _sessionStopwatch.start();
      _startQuestionTimer();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> retryFetch() async {
    if (_currentConfig != null) {
      await startQuiz(_currentConfig!);
    }
  }

  void _startQuestionTimer() {
    _cancelTimer();
    _remainingSeconds = _questionDurationSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _cancelTimer();
        _onTimeOut();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimeOut() {
    final question = currentQuestion;
    if (question != null && !question.isAnswered) {
      question.isTimedOut = true;
      notifyListeners();

      Timer(const Duration(milliseconds: 1500), () {
        if (!_isQuizCompleted && question.isTimedOut && currentQuestion == question) {
          nextQuestion();
        }
      });
    }
  }

  void _convertToMultipleSelection() {
    for (final q in _questions) {
      if (q.shuffledAnswers.length > 2) {
        final extra = q.incorrectAnswers.isNotEmpty ? q.incorrectAnswers.first : null;
        if (extra != null) {
          q.correctAnswers = [q.correctAnswer, extra];
        }
      }
    }
  }

  void submitAnswer(String selectedAnswer) {
    final question = currentQuestion;
    if (question == null || question.isAnswered) return;

    _cancelTimer();
    question.selectedAnswer = selectedAnswer;
    question.selectedAnswers = [selectedAnswer];
    question.isSubmitted = true;

    if (question.isCorrect) {
      _score++;
    }

    notifyListeners();
  }

  void toggleSelection(String answer) {
    final question = currentQuestion;
    if (question == null || question.isAnswered) return;

    if (question.selectedAnswers.contains(answer)) {
      question.selectedAnswers.remove(answer);
    } else {
      question.selectedAnswers.add(answer);
    }

    notifyListeners();
  }

  void submitMultipleSelection() {
    final question = currentQuestion;
    if (question == null || question.isAnswered || question.selectedAnswers.isEmpty) {
      return;
    }

    _cancelTimer();
    question.selectedAnswer = null;
    question.isSubmitted = true;

    if (question.isCorrect) {
      _score++;
    }

    notifyListeners();
  }

  void nextQuestion() {
    _cancelTimer();

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _startQuestionTimer();
      notifyListeners();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    _cancelTimer();
    _sessionStopwatch.stop();
    _totalElapsedSeconds = _sessionStopwatch.elapsed.inSeconds;
    _isQuizCompleted = true;
    notifyListeners();
  }

  void resetQuiz() {
    _cancelTimer();
    _sessionStopwatch.reset();
    _questions = [];
    _currentIndex = 0;
    _score = 0;
    _isLoading = false;
    _errorMessage = null;
    _isQuizCompleted = false;
    _totalElapsedSeconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimer();
    _sessionStopwatch.stop();
    super.dispose();
  }
}
