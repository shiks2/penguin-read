import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/reader/presentation/bloc/reader_bloc.dart';
import '../../features/reader/presentation/pages/reader_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../injection_container.dart' as di;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login', // Default start, but user can skip
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => BlocProvider(
          create: (_) => di.sl<DashboardBloc>(),
          child: const DashboardPage(),
        ),
      ),
      GoRoute(
        path: '/reader',
        builder: (context, state) {
          final text = state.extra as String? ?? '';
          // Inject ReaderBloc here since it's scoped to this page
          return BlocProvider(
            create: (_) => di.sl<ReaderBloc>(),
            child: ReaderPage(text: text),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
