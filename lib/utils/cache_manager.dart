import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerService {
  static final CacheManager customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 20),
      maxNrOfCacheObjects: 500,
    ),
  );
}
