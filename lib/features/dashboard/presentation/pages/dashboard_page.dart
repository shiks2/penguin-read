import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'dart:math';

import '../../../../core/constants/content_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadLibrary());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultTextStyle(
          style: GoogleFonts.spaceMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('PenguinRead'),
            ],
            isRepeatingAnimation: true,
            pause: const Duration(milliseconds: 100),
            onFinished: () {
              // Optional: actions when animation finishes
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return PopupMenuButton<String>(
                  offset: const Offset(0, 48),
                  icon: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    child: Text(
                      state.user.email?.substring(0, 1).toUpperCase() ?? 'U',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      enabled: false,
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              }
              // Guest or Initial
              return TextButton.icon(
                onPressed: () {
                  context.go('/login');
                },
                icon: const Icon(Icons.login),
                label: const Text('Login'),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Animated Header
                SizedBox(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularText(
                        children: [
                          TextItem(
                            text: Text(
                              '• FOCUS • SPEED • RETAIN •',
                              style: GoogleFonts.spaceMono(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                            space: 12,
                            startAngle: -90,
                            startAngleAlignment: StartAngleAlignment.center,
                            direction: CircularTextDirection.clockwise,
                          ),
                        ],
                        radius: 110,
                        position: CircularTextPosition.inside,
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .rotate(duration: 15.seconds),
                      Image.asset(
                        'assets/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      )
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.easeOutBack),
                    ],
                  ),
                ),

                // Daily Inspiration
                Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'DAILY INSPIRATION',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ContentConstants.dailyQuotes[Random()
                              .nextInt(ContentConstants.dailyQuotes.length)],
                          style: GoogleFonts.zillaSlab(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .slideY(begin: 0.2, end: 0, duration: 600.ms)
                    .fadeIn(),

                const SizedBox(height: 32),

                Text(
                  'Start Reading',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FormBuilder(
                  key: _formKey,
                  child: FormBuilderTextField(
                    name: 'text',
                    maxLines: 10,
                    minLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Paste your text here...',
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    validator: FormBuilderValidators.required(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final text =
                            _formKey.currentState!.value['text'] as String;
                        // Navigate to Reader with text
                        context.push('/reader', extra: text);
                      }
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'Start Reading',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Quick Library',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoaded) {
                      final items = state.texts;
                      if (items.isEmpty) {
                        return const Center(child: Text('No texts available.'));
                      }

                      return Column(
                        children: [
                          SizedBox(
                            height: 220,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        _formKey.currentState?.fields['text']
                                            ?.didChange(item.content);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item.author ?? 'Unknown Author',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            const Align(
                                              alignment: Alignment.bottomRight,
                                              child: Icon(Icons.arrow_forward),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: items.length,
                            effect: WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ).animate().slideX(begin: 0.2, duration: 600.ms).fadeIn();
                    } else if (state is DashboardError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 48),

                // Pro Tip Section
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: Theme.of(context).colorScheme.tertiary),
                        const SizedBox(width: 8),
                        Text(
                          'DID YOU KNOW?',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ContentConstants.proTips[Random()
                          .nextInt(ContentConstants.proTips.length)]['body']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
