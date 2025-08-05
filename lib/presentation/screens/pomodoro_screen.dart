import 'dart:async';
import 'package:flutter/material.dart';


import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const int focusMinutes = 25;
  static const int shortBreakMinutes = 5;
  static const int longBreakMinutes = 15;

  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  String _mode = 'focus'; // focus, short, long

  @override
  void initState() {
    super.initState();
    _setMode('focus');
  }

  void _setMode(String mode) {
    setState(() {
      _mode = mode;
      if (mode == 'focus') {
        _remainingSeconds = focusMinutes * 60;
      } else if (mode == 'short') {
        _remainingSeconds = shortBreakMinutes * 60;
      } else if (mode == 'long') {
        _remainingSeconds = longBreakMinutes * 60;
      }
      _isRunning = false;
      _timer?.cancel();
    });
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        setState(() => _isRunning = false);
        _showSnack("Temps écoulé !");
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _setMode(_mode);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text("Pomodoro"),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Sélecteur de mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ModeButton(label: "Focus", selected: _mode == 'focus', onTap: () => _setMode('focus')),
                _ModeButton(label: "Pause courte", selected: _mode == 'short', onTap: () => _setMode('short')),
                _ModeButton(label: "Pause longue", selected: _mode == 'long', onTap: () => _setMode('long')),
              ],
            ),
            const SizedBox(height: 40),
            // Timer affichage
            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Boutons de contrôle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? "Pause" : "Start"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppColors.softBlue : Colors.grey[300],
        foregroundColor: selected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(label),
    );
  }
}
