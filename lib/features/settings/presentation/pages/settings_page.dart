import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final isDark = state.themeMode == ThemeMode.dark;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Theme Section
              Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle app theme'),
                  value: isDark,
                  onChanged: (value) {
                    context.read<SettingsCubit>().toggleTheme(value);
                  },
                  secondary:  Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                ),
              ),
              const SizedBox(height: 16),
              
              // Appearance Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.text_fields),
                          const SizedBox(width: 8),
                          Text('Font Size', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Slider(
                        value: state.fontSize,
                        min: 16.0,
                        max: 60.0,
                        divisions: 44,
                        label: state.fontSize.round().toString(),
                        onChanged: (value) {
                          context.read<SettingsCubit>().updateFontSize(value);
                        },
                      ),
                      Center(
                        child: Text(
                          'Preview Text',
                          style: TextStyle(fontSize: state.fontSize),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Reading Preferences Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Row(
                        children: [
                          const Icon(Icons.speed),
                          const SizedBox(width: 8),
                          Text('Default Speed', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      const SizedBox(height: 16),
                       Slider(
                        value: state.defaultWpm.toDouble(),
                        min: AppConstants.minWPM.toDouble(),
                        max: AppConstants.maxWPM.toDouble(),
                        divisions: (AppConstants.maxWPM - AppConstants.minWPM) ~/ 50,
                        label: '${state.defaultWpm} WPM',
                        onChanged: (value) {
                          context.read<SettingsCubit>().updateDefaultWpm(value.toInt());
                        },
                      ),
                       Center(
                        child: Text('${state.defaultWpm} WPM'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
