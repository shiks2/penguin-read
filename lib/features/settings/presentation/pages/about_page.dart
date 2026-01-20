import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/content_constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        child: Column(
          children: [
            // Header Section
            Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 100,
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 16),
                Text(
                  ContentConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  ContentConstants.appVersion,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Mission Section
            // Making it centered text without a card for cleaner look as implied by request "centered or justified"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                ContentConstants.aboutDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(duration: 800.ms),

            const SizedBox(height: 40),

            // Contribute Banner
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      '🚀 ${ContentConstants.contributeTitle}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ContentConstants.contributeBody,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => launchUrl(
                              Uri.parse(ContentConstants.githubRepoUrl)),
                          icon: const FaIcon(FontAwesomeIcons.github, size: 18),
                          label: const Text('View Source'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => launchUrl(
                              Uri.parse(ContentConstants.githubIssuesUrl)),
                          icon: const Icon(Icons.bug_report, size: 18),
                          label: const Text('Report Issue'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms)
                .fadeIn(),

            const SizedBox(height: 40),

            // Developer Footer
            ListTile(
              leading: const CircleAvatar(
                child: FaIcon(FontAwesomeIcons.userAstronaut, size: 20),
              ),
              title: const Text('Developed by Shiks2'),
              subtitle: const Text('Built with Flutter & Clean Architecture'),
              trailing: IconButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () =>
                    launchUrl(Uri.parse('https://github.com/shiks2')),
              ),
              contentPadding: EdgeInsets.zero,
            )
                .animate()
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 400.ms)
                .fadeIn(),

            const SizedBox(height: 16),

            // Legal
            Wrap(
              spacing: 16,
              alignment: WrapAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Privacy Policy',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Terms of Use',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),
            Center(
              child: Text(
                'Made with 💙 and Flutter',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
