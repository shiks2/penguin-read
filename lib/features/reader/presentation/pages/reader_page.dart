import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/anchor_text_builder.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../bloc/reader_bloc.dart';
import '../widgets/celebration_overlay.dart';
import '../widgets/guided_paragraph_view.dart';

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

  // We use this key to access the GuidedView state if needed, but Bloc drives sync.

  @override
  void initState() {
    super.initState();
    // Get default WPM from Settings
    final defaultWpm = context.read<SettingsCubit>().state.defaultWpm;

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
    return BlocListener<ReaderBloc, ReaderState>(
      listenWhen: (previous, current) =>
          !previous.isCompleted && current.isCompleted,
      listener: (context, state) {
        setState(() {
          _showCelebration = true;
        });
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Reading Session'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.speed), text: "Speed (RSVP)"),
                Tab(icon: Icon(Icons.menu_book), text: "Study (Guided)"),
              ],
            ),
          ),
          body: Stack(
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

                  // If empty or loading
                  if (state.session.words.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    physics:
                        const NeverScrollableScrollPhysics(), // Prevent conflict swipe
                    children: [
                      // TAB 1: Classic RSVP
                      Column(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Center(
                              child: _buildRSVPWord(
                                  context, state.session.currentWord),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildControls(context, state),
                          ),
                        ],
                      ),

                      // TAB 2: Guided Paragraph
                      Column(
                        children: [
                          Expanded(
                            child: GuidedParagraphView(
                              words: state.session.words,
                              currentIndex: state.session.currentWordIndex,
                              isPlaying: state.session.isPlaying,
                              wpm: state.session.wpm,
                              onIndexChanged: (newIndex) {
                                context
                                    .read<ReaderBloc>()
                                    .add(ReaderIndexUpdated(newIndex));
                              },
                            ),
                          ),
                          // Reuse controls for Study mode too
                          SizedBox(
                            height: 120, // Compact controls
                            child: _buildControls(context, state),
                          ),
                        ],
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
              fontFamily: 'Courier New', // Monospace helps alignment
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

    final int centerIndex = (word.length / 2).floor();
    final String prefix = word.substring(0, centerIndex);
    final String centerChar = word[centerIndex];
    final String suffix = word.substring(centerIndex + 1);
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: state.session.progress,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              FloatingActionButton(
                onPressed: () {
                  if (state.session.isPlaying) {
                    context.read<ReaderBloc>().add(ReaderPaused());
                  } else {
                    context.read<ReaderBloc>().add(ReaderResumed());
                  }
                },
                mini: true, // Make it simpler for shared layout
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
