import 'package:crypto/crypto.dart';
import 'package:csp_hasher/csp_hasher.dart';
import 'package:test/test.dart';

void main() {
  group('CspHash', () {
    test('toString returns the correct format', () {
      final hash = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      expect(hash.toString(), equals('''"'sha256-abc123'"'''));
    });

    test('equality works correctly', () {
      final hash1 = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      final hash2 = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      final hash3 = CspHash(
        lineNumber: 2,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      final hash4 = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'def456',
        hashMode: HashMode.script,
      );
      expect(hash1, equals(hash2));
      expect(hash1, isNot(equals(hash3)));
      expect(hash1, isNot(equals(hash4)));
    });

    test('hashCode works correctly', () {
      final hash1 = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      final hash2 = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      final hash3 = CspHash(
        lineNumber: 2,
        hashType: sha256,
        hash: 'abc123',
        hashMode: HashMode.script,
      );
      final hash4 = CspHash(
        lineNumber: 1,
        hashType: sha256,
        hash: 'def456',
        hashMode: HashMode.script,
      );
      expect(hash1.hashCode, equals(hash2.hashCode));
      expect(hash1.hashCode, isNot(equals(hash3.hashCode)));
      expect(hash1.hashCode, isNot(equals(hash4.hashCode)));
    });
  });
}
