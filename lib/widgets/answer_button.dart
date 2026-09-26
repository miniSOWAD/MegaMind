import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final String? selectedAnswer;
  final List<String> selectedAnswers;
  final List<String> correctAnswers;
  final bool isAnswered;
  final bool allowMultipleSelection;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.text,
    required this.selectedAnswer,
    required this.selectedAnswers,
    required this.correctAnswers,
    required this.isAnswered,
    required this.allowMultipleSelection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = const Color(0xFFE2E8F0);
    Color textColor = AppTheme.textPrimary;
    Widget? trailingIcon;

    final bool isThisSelected =
        selectedAnswers.contains(text) || selectedAnswer == text;
    final bool isThisCorrect = correctAnswers.contains(text);

    if (isAnswered) {
      if (isThisCorrect) {
        backgroundColor = AppTheme.correctLight;
        borderColor = AppTheme.correct;
        textColor = const Color(0xFF065F46);
        trailingIcon = const Icon(
          Icons.check_circle,
          color: AppTheme.correct,
          size: 22,
        );
      } else if (isThisSelected) {
        backgroundColor = AppTheme.incorrectLight;
        borderColor = AppTheme.incorrect;
        textColor = const Color(0xFF991B1B);
        trailingIcon = const Icon(
          Icons.cancel,
          color: AppTheme.incorrect,
          size: 22,
        );
      } else {
        backgroundColor = const Color(0xFFF8FAFC);
        borderColor = const Color(0xFFE2E8F0);
        textColor = AppTheme.textMuted;
      }
    } else if (isThisSelected) {
      backgroundColor = AppTheme.primaryLight.withValues(alpha: 0.55);
      borderColor = AppTheme.primary;
      textColor = AppTheme.primary;
      trailingIcon = Icon(
        allowMultipleSelection
            ? Icons.check_box_rounded
            : Icons.radio_button_checked_rounded,
        color: AppTheme.primary,
        size: 22,
      );
    } else if (allowMultipleSelection) {
      trailingIcon = const Icon(
        Icons.check_box_outline_blank_rounded,
        color: AppTheme.textMuted,
        size: 22,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                if (!isAnswered)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isThisSelected || (isAnswered && isThisCorrect)
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: textColor,
                      height: 1.3,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 10),
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
