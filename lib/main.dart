import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/common/presentation/cubit/network_cubit.dart';
import 'core/widgets/no_internet_widget.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (e) {
      // Ignore if fails
    }
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://kyrwezdztzeooossowcx.supabase.co',
    anonKey: 'sb_publishable_mjq1MkDHdUKsx5juNej5vQ_D1Mbi_1i',
  );

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => di.sl<SettingsCubit>()..loadSettings(),
        ),
        BlocProvider(
          create: (_) => di.sl<NetworkCubit>(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode, // Applied logic
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  BlocBuilder<NetworkCubit, NetworkState>(
                    builder: (context, state) {
                      if (state.status == NetworkStatus.offline) {
                        return const Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: NoInternetOverlay(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
