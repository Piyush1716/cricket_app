import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager extends CacheManager {
  static const key = "customCacheKey";

  static CustomCacheManager _instance = CustomCacheManager._();

  factory CustomCacheManager() {
    return _instance;
  }

  CustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: Duration(minutes: 5), // Cache expiry set to 30 days
            maxNrOfCacheObjects: 100, // Store up to 100 files
          ),
        );
}
