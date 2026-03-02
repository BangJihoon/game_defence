// lib/menu/pages/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onStartGame;
  final VoidCallback onToggleLocale;
  final Locale locale;

  const HomePage({
    super.key,
    required this.onStartGame,
    required this.onToggleLocale,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0F0F1E).withValues(alpha: 0.8),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // 고전적이고 웅장한 타이틀
              const Text(
                'DIVINE\nDEFENSE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  height: 0.9,
                  shadows: [
                    Shadow(color: Colors.orange, blurRadius: 20),
                    Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                locale.languageCode == 'ko' ? '신의 신탁과 영웅들의 전쟁' : 'The Oracle & Heroic War',
                style: const TextStyle(color: Colors.white54, fontSize: 16, letterSpacing: 2),
              ),
              const Spacer(flex: 3),
              // 시작 버튼 (화면을 꽉 채우는 큰 버튼)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: onStartGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 10,
                    shadowColor: Colors.orangeAccent,
                  ),
                  child: Text(
                    locale.languageCode == 'ko' ? '운명의 전쟁 시작' : 'START THE WAR',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onToggleLocale,
                child: Text(
                  locale.languageCode == 'ko' ? 'Change to English' : '한국어로 변경',
                  style: const TextStyle(color: Colors.cyanAccent),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
