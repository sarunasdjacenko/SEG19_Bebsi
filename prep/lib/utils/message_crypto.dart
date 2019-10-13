import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:hex/hex.dart';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';

/// Performs messaging crypto. Contains methods for encrypting and
/// decrypting a message.
class MessageCrypto {
  /// Initialises the singleton
  static const MessageCrypto _singleton = MessageCrypto._internal();
  factory MessageCrypto() => _singleton;
  const MessageCrypto._internal();

  /// Encrypts an unencrypted message and returns the encrypted message.
  static String encryptMessage(String appointmentID, String message) {
    Random rand = Random.secure();
    int ivArrayLength = 16;
    Uint8List iv = Uint8List(ivArrayLength);
    for (int i = 0; i < ivArrayLength; ++i) {
      iv[i] = rand.nextInt(256);
    }

    PaddedBlockCipher cipher = _getCipher(true, appointmentID, iv);
    String encryptedMessage =
        HEX.encode(iv) + HEX.encode(cipher.process(utf8.encode(message)));
    return encryptedMessage;
  }

  /// Decrypts an encrypted message and returns the decrypted message.
  static String decryptMessage(String appointmentID, String message) {
    String decryptedMessage;
    try {
      String encodedIV = message.substring(0, 32);
      Uint8List iv = HEX.decode(encodedIV);

      PaddedBlockCipher cipher = _getCipher(false, appointmentID, iv);
      String encodedMessage = message.substring(32);

      decryptedMessage = utf8.decode(cipher.process(HEX.decode(encodedMessage)));
    } catch (Exception) {
      decryptedMessage = '';
    }
    return decryptedMessage;
  }

  /// Creates the algorithm used to encrypt and decrypt messages.
  static PaddedBlockCipher _getCipher(
      bool mode, String appointmentID, Uint8List iv) {
    Digest md5 = Digest("MD5");
    String hexEncryptedIV = HEX.encode(md5.process(iv));
    Uint8List keyArray = utf8.encode(appointmentID + hexEncryptedIV);
    String hexEncryptedKey = HEX.encode(md5.process(keyArray));
    Uint8List encryptedKeyArray = utf8.encode(hexEncryptedKey);

    Mac mac = new Mac("SHA-512/HMAC");
    mac.init(KeyParameter(encryptedKeyArray));
    String keyHash = HEX.encode(mac.process(Uint8List(0))).substring(0, 32);
    Uint8List keyHashList = utf8.encode(keyHash);

    PaddedBlockCipher cipher = PaddedBlockCipherImpl(
      PKCS7Padding(),
      CBCBlockCipher(AESFastEngine()),
    );

    cipher.init(
      mode ? true : false,
      PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
        ParametersWithIV<KeyParameter>(KeyParameter(keyHashList), iv),
        null,
      ),
    );
    return cipher;
  }
}
