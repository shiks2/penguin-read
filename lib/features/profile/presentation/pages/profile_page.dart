import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/weekly_activity_chart.dart'; // Will move this here

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Stats',
          style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileGuest) {
            return _buildGuestView(context);
          } else if (state is ProfileLoaded) {
            return _buildUserView(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SeparatedColumn(
          separatorBuilder: () => const SizedBox(height: 16),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_clock,
                    size: 64, color: Theme.of(context).colorScheme.outline)
                .animate()
                .shake(duration: 500.ms),
            Text(
              "Track Your Progress",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Sign in to access your reading history, analytics, and trophy room.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                // Navigate to Login, clear stack essentially or just push
                // Ideally we use go_router to go to /login
                context.go('/login');
              },
              icon: const Icon(Icons.login),
              label: const Text("Login / Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserView(BuildContext context, ProfileLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SeparatedColumn(
        separatorBuilder: () => const SizedBox(height: 32),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header
          Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  state.userEmail.isNotEmpty
                      ? state.userEmail[0].toUpperCase()
                      : 'U',
                  style: GoogleFonts.spaceMono(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                state.userEmail,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Speed Reader", // Placeholder for joined date
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ],
          ),

          // 2. Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  "Total Words",
                  "${(state.totalWordsRead / 1000).toStringAsFixed(1)}k",
                  Icons.menu_book,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  "Best Speed",
                  "${state.bestWpm} WPM",
                  Icons.speed,
                ),
              ),
            ],
          ).animate().slideY(begin: 0.2, duration: 400.ms).fadeIn(),

          // 3. Weekly Activity Chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last 7 Days",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: WeeklyActivityChart(sessions: state.sessions),
                ),
              ],
            ),
          )
              .animate()
              .slideY(begin: 0.2, delay: 200.ms, duration: 400.ms)
              .fadeIn(),

          // 4. Logout Action
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              // Navigator pop is handled by AuthBloc listener usually,
              // but just in case we are in a sub-route:
              // Actually AuthBloc listener at top level usually handles routing on AuthUnauthenticated
              // So we just wait for that.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
