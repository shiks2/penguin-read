import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/text_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<TextEntity>>> fetchPublicTexts();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final SupabaseClient supabaseClient;

  DashboardRepositoryImpl({required this.supabaseClient});

  @override
  Future<Either<Failure, List<TextEntity>>> fetchPublicTexts() async {
    try {
      // Fetch top 10 texts ordered by creation date
      final data = await supabaseClient
          .from('public_texts')
          .select()
          .order('created_at', ascending: false)
          .limit(10);

      final List<TextEntity> texts = (data as List<dynamic>)
          .map((e) => TextEntity.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(texts);
    } catch (e) {
      // Fallback to local sample texts on any error (network or missing table)
      // This ensures the app always has content.
      try {
        final fallbackTexts = AppConstants.sampleTexts.map((e) {
          return TextEntity(
            id: 'local_${e['title'].hashCode}',
            title: e['title']!,
            content: e['text']!,
            author: 'PenguinRead Sample',
          );
        }).toList();
        
        return Right(fallbackTexts);
      } catch (fallbackError) {
         return const Left(ServerFailure('Server Failure'));
      }
    }
  }
}
