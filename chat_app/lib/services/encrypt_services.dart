import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptServices {
  final _key = Key.fromUtf8(dotenv.env['ENCRYPT_KEY']!);
  final iv = IV.fromLength(16);
  String encrypt(String text) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted.base64;
  }

  String decrypt(String text, String ivKEY) {
    final encrypter = Encrypter(AES(_key));
    print("Krish" + ivKEY);

    final decrypted =
        encrypter.decrypt(Encrypted.fromBase64(text), iv: IV.fromBase64(ivKEY));
    return decrypted;
  }
}
