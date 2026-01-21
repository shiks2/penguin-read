import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/settings_local_data_source.dart';

// State
class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final double fontSize;
  final int defaultWpm;
  final bool isAnchorMode;

  const SettingsState({
    required this.themeMode,
    required this.fontSize,
    required this.defaultWpm,
    required this.isAnchorMode,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      themeMode: ThemeMode.system,
      fontSize: 32.0,
      defaultWpm: 300,
      isAnchorMode: false,
    );
  }

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    int? defaultWpm,
    bool? isAnchorMode,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      defaultWpm: defaultWpm ?? this.defaultWpm,
      isAnchorMode: isAnchorMode ?? this.isAnchorMode,
    );
  }

  @override
  List<Object> get props => [themeMode, fontSize, defaultWpm, isAnchorMode];
}

// Cubit
class SettingsCubit extends Cubit<SettingsState> {
  final SettingsLocalDataSource localDataSource;

  SettingsCubit({required this.localDataSource})
      : super(SettingsState.initial());

  Future<void> loadSettings() async {
    final isDark = await localDataSource.getThemeMode();
    final fontSize = await localDataSource.getFontSize();
    final defaultWpm = await localDataSource.getDefaultWpm();
    final isAnchorMode = await localDataSource.getIsAnchorMode() ?? false;

    ThemeMode mode = ThemeMode.system;
    if (isDark != null) {
      mode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    emit(state.copyWith(
      themeMode: mode,
      fontSize: fontSize,
      defaultWpm: defaultWpm,
      isAnchorMode: isAnchorMode,
    ));
  }

  Future<void> toggleAnchorMode(bool value) async {
    await localDataSource.saveIsAnchorMode(value);
    emit(state.copyWith(isAnchorMode: value));
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
