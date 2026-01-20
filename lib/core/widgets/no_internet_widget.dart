import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NoInternetOverlay extends StatelessWidget {
  const NoInternetOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.redAccent,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              "No Internet Connection. offline mode active.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideY(begin: 1, end: 0, duration: 300.ms, curve: Curves.easeOut);
  }
}
