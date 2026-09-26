import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'category_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF5FBFF), Color(0xFFEDE9FE)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                    boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: .25), blurRadius: 30, offset: const Offset(0, 15))],
                  ),
                  child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 70),
                ),
                const SizedBox(height: 28),
                const Text('MegaMind', style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                const Text('Challenge your brain with thousands of trivia questions. Learn, compete and improve your knowledge.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppTheme.textSecondary, height: 1.5)),
                const SizedBox(height: 28),
                _feature(Icons.category_rounded, 'Multiple Categories', 'Science, history, sports and more'),
                _feature(Icons.timer_rounded, 'Smart Timer Challenge', 'Improve speed and accuracy'),
                _feature(Icons.insights_rounded, 'Performance Insights', 'Track your quiz progress'),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start Quiz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategorySelectionScreen())),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _feature(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        CircleAvatar(backgroundColor: AppTheme.primaryLight, child: Icon(icon, color: AppTheme.primary)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary)), Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary))]))
      ]),
    );
  }
}
