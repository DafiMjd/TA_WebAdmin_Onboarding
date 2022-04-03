import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  const secureStorage = FlutterSecureStorage();
  // if key not exists return null
  final encryprionKey = await secureStorage.read(key: 'key');
  if (encryprionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptionKey = base64Url.decode(key!);
  print('Encryption key: $encryptionKey');
  final encryptedBox= await Hive.openBox('vaultBox', encryptionCipher: HiveAesCipher(encryptionKey));
  encryptedBox.put('secret', 'Hive is cool');
  print(encryptedBox.get('secret'));
}