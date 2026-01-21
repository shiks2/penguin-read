import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CelebrationOverlay extends StatefulWidget {
  final int wpm;
  final int totalWords;
  final VoidCallback onDismiss;

  const CelebrationOverlay({
    super.key,
    required this.wpm,
    required this.totalWords,
    required this.onDismiss,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  @override
  void initState() {
    super.initState();
    // Auto dismiss after 3.5 seconds (giving some buffer)
    Future.delayed(const Duration(milliseconds: 3500), widget.onDismiss);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark background with blur/opacity
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.8),
          ).animate().fadeIn(duration: 500.ms),
        ),

        // Snowfall Effect
        const Positioned.fill(child: SnowfallWidget()),

        // Content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Read Complete! 🐧',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .then()
                  .shimmer(duration: 1000.ms),
              const SizedBox(height: 16),
              Text(
                'You just read ${widget.totalWords} words at ${widget.wpm} WPM.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .slideY(begin: 0.5, end: 0, duration: 600.ms, delay: 200.ms)
                  .fadeIn(),
            ],
          ),
        ),
      ],
    );
  }
}

class SnowfallWidget extends StatefulWidget {
  const SnowfallWidget({super.key});

  @override
  State<SnowfallWidget> createState() => _SnowfallWidgetState();
}

class _SnowfallWidgetState extends State<SnowfallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();

    // Generate snowflakes
    for (int i = 0; i < 100; i++) {
      _snowflakes.add(Snowflake(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 2,
        speed: _random.nextDouble() * 0.2 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SnowPainter(_snowflakes, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Snowflake {
  double x;
  double y;
  double size;
  double speed;

  Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double animationValue;

  SnowPainter(this.snowflakes, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.8);

    for (var flake in snowflakes) {
      // Move flake down based on its speed
      double y = (flake.y + animationValue * 20 * flake.speed) % 1.0;

      canvas.drawCircle(
        Offset(flake.x * size.width, y * size.height),
        flake.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
