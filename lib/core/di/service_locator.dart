import 'package:get_it/get_it.dart';

import '../storage/secure_storage_service.dart';

/// Global service locator using [GetIt].
///
/// Call [ServiceLocator.init] once during app startup to register
/// and initialise all services.
final GetIt sl = GetIt.instance;

abstract final class ServiceLocator {
  /// Registers and initialises all application services.
  ///
  /// Must be `await`ed in `main()` before `runApp()`.
  static Future<void> init() async {
    // Register the encrypted storage service as a lazy singleton.
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(),
    );

    // Eagerly initialise storage (opens encrypted Hive boxes).
    await sl<SecureStorageService>().init();
  }
}
