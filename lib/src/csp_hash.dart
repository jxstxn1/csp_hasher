import 'package:crypto/crypto.dart';
import 'package:csp_hasher/src/extensions.dart';

/// A class that represents a hash for a CSP policy
class CspHash {
  final int lineNumber;
  final Hash hashType;
  final String hash;

  CspHash({
    required this.lineNumber,
    required this.hashType,
    required this.hash,
  });

  @override
  String toString() {
    return '''"'${hashType.typeToString}-$hash'"''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CspHash &&
          runtimeType == other.runtimeType &&
          lineNumber == other.lineNumber &&
          hashType == other.hashType &&
          hash == other.hash;

  @override
  int get hashCode => hash.hashCode ^ hashType.hashCode ^ lineNumber.hashCode;
}
