import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the AES-256 encryption key used to encrypt Hive boxes.
///
/// The key is generated once on first launch and persisted in the
/// platform-native secure storage (Android Keystore / iOS Keychain).
/// It never leaves the secure enclave in plaintext.
class EncryptionKeyManager {
  EncryptionKeyManager({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _keyAlias = 'daily_app_hive_encryption_key';
  final FlutterSecureStorage _secureStorage;

  /// Returns the 256-bit key as a [Uint8List] suitable for [HiveAesCipher].
  ///
  /// If no key exists yet, a cryptographically random one is generated and
  /// stored in secure storage.
  Future<Uint8List> getOrCreateKey() async {
    final existingBase64 = await _secureStorage.read(key: _keyAlias);

    if (existingBase64 != null) {
      return base64Url.decode(existingBase64);
    }

    // Generate a 32-byte (256-bit) random key.
    final random = Random.secure();
    final key = Uint8List.fromList(
      List<int>.generate(32, (_) => random.nextInt(256)),
    );

    await _secureStorage.write(
      key: _keyAlias,
      value: base64Url.encode(key),
    );

    return key;
  }

  /// Deletes the stored key. **Warning:** this makes all previously
  /// encrypted data unrecoverable.
  Future<void> deleteKey() async {
    await _secureStorage.delete(key: _keyAlias);
  }
}
