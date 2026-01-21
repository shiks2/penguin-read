import 'dart:async';
import 'package:flutter/material.dart';

class GuidedParagraphView extends StatefulWidget {
  final List<String> words;
  final int currentIndex;
  final bool isPlaying;
  final int wpm;
  // Callback to update the global BLoC index
  final Function(int) onIndexChanged;

  const GuidedParagraphView({
    super.key,
    required this.words,
    required this.currentIndex,
    required this.isPlaying,
    required this.wpm,
    required this.onIndexChanged,
  });

  @override
  State<GuidedParagraphView> createState() => _GuidedParagraphViewState();
}

class _GuidedParagraphViewState extends State<GuidedParagraphView> {
  Timer? _timer;
  final ScrollController _scrollController = ScrollController();

  // Local state to track progress if needed, but we rely on parent mainly
  // We use this local index to drive the UI updates smoothly
  late int _localIndex;

  @override
  void initState() {
    super.initState();
    _localIndex = widget.currentIndex;
    if (widget.isPlaying) _startTimer();
  }

  @override
  void didUpdateWidget(GuidedParagraphView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync external changes (e.g. paused/play from parent)
    if (widget.currentIndex != oldWidget.currentIndex) {
      _localIndex = widget.currentIndex;
    }

    if (widget.isPlaying != oldWidget.isPlaying) {
      widget.isPlaying ? _startTimer() : _stopTimer();
    }

    if (widget.wpm != oldWidget.wpm && widget.isPlaying) {
      _stopTimer();
      _startTimer();
    }
  }

  void _startTimer() {
    // Avoid division by zero
    if (widget.wpm <= 0) return;
    int millisPerWord = (60000 / widget.wpm).round();
    _timer = Timer.periodic(Duration(milliseconds: millisPerWord), (timer) {
      if (_localIndex < widget.words.length - 1) {
        setState(() {
          _localIndex++;
        });
        widget.onIndexChanged(_localIndex); // Notify parent Bloc
        _autoScroll();
      } else {
        _stopTimer();
      }
    });
  }

  void _autoScroll() {
    // MVP Scroll Logic: Scroll down slightly every ~20 words
    if (_localIndex > 0 && _localIndex % 20 == 0) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.offset + 60, // Scroll down 60 pixels
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Auto-scroll to current position on build if clear mismatch?
    // Usually simpler to just rely on autoScroll trigger.

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyLarge?.color,
            height: 1.6,
            fontFamily: 'Roboto', // Ensure good readability
          ),
          children: List.generate(widget.words.length, (index) {
            bool isCurrent = index == _localIndex;
            return TextSpan(
              text: "${widget.words[index]} ",
              style: TextStyle(
                // Highlight logic
                backgroundColor: isCurrent
                    ? Colors.yellow.withValues(alpha: 0.3)
                    : Colors.transparent,
                color: (isCurrent
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color)
                    ?.withValues(alpha: isCurrent ? 1.0 : 0.7),
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }),
        ),
      ),
    );
  }
}
