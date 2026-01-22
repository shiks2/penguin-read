import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart' as di;
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Validation: Check connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Check if we already have a session to avoid flicker
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            return _buildDashboard();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;

        // If session exists, user is logged in
        if (session != null) {
          return _buildDashboard();
        }

        // Otherwise, show login
        return const LoginPage();
      },
    );
  }

  Widget _buildDashboard() {
    return BlocProvider(
      create: (_) => di.sl<DashboardBloc>(),
      child: const DashboardPage(),
    );
  }
}
