import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/anchor_text_builder.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../bloc/reader_bloc.dart';
import '../widgets/celebration_overlay.dart';

class ReaderPage extends StatefulWidget {
  final String text;

  const ReaderPage({
    super.key,
    required this.text,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  bool _showCelebration = false;
  @override
  void initState() {
    super.initState();
    // Get default WPM from Settings
    final defaultWpm = context.read<SettingsCubit>().state.defaultWpm;

    // Dispatch start event via a customized event or just update WPM immediately after start?
    // Let's modify ReaderBloc to accept initial WPM or just update it right after start.
    context.read<ReaderBloc>().add(ReaderStarted(widget.text));
    context.read<ReaderBloc>().add(ReaderWPMUpdated(defaultWpm));
  }

  @override
  void deactivate() {
    // Ensure we stop/pause when leaving
    context.read<ReaderBloc>().add(ReaderStopped());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    // Using LayoutBuilder to ensure responsiveness (text size adaptation)
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Reading Session'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<ReaderBloc, ReaderState>(
        listenWhen: (previous, current) =>
            !previous.isCompleted && current.isCompleted,
        listener: (context, state) {
          setState(() {
            _showCelebration = true;
          });
        },
        child: Stack(
          children: [
            BlocBuilder<ReaderBloc, ReaderState>(
              builder: (context, state) {
                if (state.isCompleted) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Reading Completed!',
                            style: TextStyle(fontSize: 24)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<ReaderBloc>()
                                .add(ReaderStarted(widget.text));
                          },
                          child: const Text('Read Again'),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Back to Dashboard'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child:
                            _buildRSVPWord(context, state.session.currentWord),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildControls(context, state),
                    ),
                  ],
                );
              },
            ),
            if (_showCelebration &&
                context.read<ReaderBloc>().state.isCompleted)
              CelebrationOverlay(
                wpm: context.read<ReaderBloc>().state.session.wpm,
                totalWords: widget.text.split(RegExp(r'\s+')).length,
                onDismiss: () {
                  if (mounted) {
                    setState(() {
                      _showCelebration = false;
                    });
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRSVPWord(BuildContext context, String word) {
    if (word.isEmpty) return const SizedBox.shrink();

    final settingsState = context.watch<SettingsCubit>().state;
    final double fontSize = settingsState.fontSize;
    final bool isAnchorMode = settingsState.isAnchorMode;

    final TextStyle baseStyle =
        Theme.of(context).textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              letterSpacing: 1.2,
              fontFamily:
                  'Courier New', // Monospace helps alignment, though not strictly required
            );

    if (isAnchorMode) {
      return RichText(
        textAlign: TextAlign.center,
        text: AnchorTextBuilder.build(
          word: word,
          baseStyle: baseStyle,
          isAnchorMode: true,
        ),
      );
    }

    // ORP Logic: Find center
    final int centerIndex = (word.length / 2).floor();

    // Split word into 3 parts: prefix, center letter, suffix
    final String prefix = word.substring(0, centerIndex);
    final String centerChar = word[centerIndex];
    final String suffix = word.substring(centerIndex + 1);

    // Using FlexColorScheme means we have access to scheme colors.
    // Red accent for ORP.
    const Color highlightColor = Colors.redAccent;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(
              text: prefix,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          TextSpan(
              text: centerChar,
              style: const TextStyle(
                  color: highlightColor, fontWeight: FontWeight.bold)),
          TextSpan(
              text: suffix,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, ReaderState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: state.session.progress,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // WPM Slider
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Speed: ${state.session.wpm} WPM',
                        style: Theme.of(context).textTheme.bodySmall),
                    Slider(
                      value: state.session.wpm.toDouble(),
                      min: AppConstants.minWPM.toDouble(),
                      max: AppConstants.maxWPM.toDouble(),
                      divisions:
                          (AppConstants.maxWPM - AppConstants.minWPM) ~/ 50,
                      onChanged: (value) {
                        context
                            .read<ReaderBloc>()
                            .add(ReaderWPMUpdated(value.toInt()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Play/Pause
              FloatingActionButton(
                onPressed: () {
                  if (state.session.isPlaying) {
                    context.read<ReaderBloc>().add(ReaderPaused());
                  } else {
                    context.read<ReaderBloc>().add(ReaderResumed());
                  }
                },
                child: Icon(
                    state.session.isPlaying ? Icons.pause : Icons.play_arrow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
