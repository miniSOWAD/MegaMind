import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../utils/app_theme.dart';
import 'category_selection_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? _nickname;
  bool _isLoadingNickname = true;

  @override
  void initState() {
    super.initState();
    _initializeNickname();
  }

  Future<void> _initializeNickname() async {
    final savedNickname = await PreferencesService.loadNickname();
    if (!mounted) return;

    setState(() {
      _nickname = savedNickname;
      _isLoadingNickname = false;
    });

    if (savedNickname == null || savedNickname.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showNicknameDialog(forceOpen: true);
        }
      });
    }
  }

  Future<void> _showNicknameDialog({bool forceOpen = false}) async {
    final controller = TextEditingController(text: _nickname ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      barrierDismissible: !forceOpen,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose your nickname'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              maxLength: 20,
              decoration: const InputDecoration(
                hintText: 'Enter your nickname',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Nickname is required';
                }
                if (trimmed.length < 2) {
                  return 'Use at least 2 characters';
                }
                return null;
              },
            ),
          ),
          actions: [
            if (!forceOpen)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ElevatedButton(
              onPressed: () async {
                if (!(formKey.currentState?.validate() ?? false)) return;
                final nickname = controller.text.trim();
                await PreferencesService.saveNickname(nickname);
                if (!mounted) return;
                setState(() => _nickname = nickname);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _startQuiz() {
    if ((_nickname ?? '').trim().isEmpty) {
      _showNicknameDialog(forceOpen: true);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategorySelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final greetingName = _nickname?.trim();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5FBFF), Color(0xFFEDE9FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
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
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: .25),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'MegaMind',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isLoadingNickname)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          greetingName == null
                              ? 'Welcome! Let\'s set your player name.'
                              : 'Welcome, $greetingName!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Edit nickname',
                        onPressed: _isLoadingNickname
                            ? null
                            : () => _showNicknameDialog(),
                        icon: const Icon(
                          Icons.edit_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                const Text(
                  'Challenge your brain with thousands of trivia questions. Learn, compete and improve your knowledge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                _feature(
                  Icons.category_rounded,
                  'Multiple Categories',
                  'Science, history, sports and more',
                ),
                _feature(
                  Icons.timer_rounded,
                  'Smart Timer Challenge',
                  'Choose 10, 15, 20, 30, 40 or 45 seconds',
                ),
                _feature(
                  Icons.insights_rounded,
                  'Performance Insights',
                  'Track your quiz progress',
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text(
                      'Start Quiz',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _isLoadingNickname ? null : _startQuiz,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryLight,
            child: Icon(icon, color: AppTheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
