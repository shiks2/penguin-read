import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/settings_local_data_source.dart';

// State
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final double fontSize;
  final int defaultWpm;

  const SettingsState({
    required this.themeMode,
    required this.fontSize,
    required this.defaultWpm,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      themeMode: ThemeMode.system,
      fontSize: 32.0,
      defaultWpm: 300,
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    int? defaultWpm,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      defaultWpm: defaultWpm ?? this.defaultWpm,
    );
  }

  @override
  List<Object> get props => [themeMode, fontSize, defaultWpm];
}

// Cubit
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource localDataSource;

  SettingsCubit({required this.localDataSource}) : super(SettingsState.initial());

  Future<void> loadSettings() async {
    final isDark = await localDataSource.getThemeMode();
    final fontSize = await localDataSource.getFontSize();
    final defaultWpm = await localDataSource.getDefaultWpm();

    ThemeMode mode = ThemeMode.system;
    if (isDark != null) {
      mode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    emit(state.copyWith(
      themeMode: mode,
      fontSize: fontSize,
      defaultWpm: defaultWpm,
    ));
  }

  Future<void> toggleTheme(bool isDark) async {
    await localDataSource.saveThemeMode(isDark);
    emit(state.copyWith(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> updateFontSize(double newSize) async {
    await localDataSource.saveFontSize(newSize);
    emit(state.copyWith(fontSize: newSize));
  }

  Future<void> updateDefaultWpm(int newWpm) async {
    await localDataSource.saveDefaultWpm(newWpm);
    emit(state.copyWith(defaultWpm: newWpm));
  }
}
