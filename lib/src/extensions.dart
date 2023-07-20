import 'package:crypto/crypto.dart';

extension HashType on Hash {
  String get typeToString {
    switch (this) {
      case sha256:
        return 'sha256';
      case sha384:
        return 'sha384';
      case sha512:
        return 'sha512';
      default:
        throw ArgumentError('Hash type not supported');
    }
  }
}
