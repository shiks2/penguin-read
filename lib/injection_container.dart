import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/reader/presentation/bloc/reader_bloc.dart';
import 'features/settings/data/datasources/settings_local_data_source.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Information:
  // Since we are not using injectable generator for this step (to keep it simple manually as per instructions),
  // we register dependencies manually.

  // External
  // Check if Supabase is initialized before accessing client (safety check)
  try {
    final supabase = Supabase.instance.client;
    sl.registerLazySingleton(() => supabase);
  } catch (e) {
    // Supabase might fail in tests or if not initialized. 
  }
  
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  
  // Dashboard
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(supabaseClient: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  // BLoC / Cubit
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
    ),
  );
  
  sl.registerFactory(() => ReaderBloc());
  
  sl.registerFactory(() => SettingsCubit(localDataSource: sl()));
  
  sl.registerFactory(() => DashboardBloc(repository: sl()));
}
