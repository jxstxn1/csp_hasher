import 'package:crypto/crypto.dart';
import 'package:csp_hasher/src/extensions.dart';
import 'package:test/test.dart';

void main() {
  test(
    'should return sha256 if the Hash is a sha256',
    () => expect(sha256.typeToString, equals('sha256')),
  );
  test(
    'should return sha384 if the Hash is a sha384',
    () => expect(sha384.typeToString, equals('sha384')),
  );
  test(
    'should return sha512 if the Hash is a sha512',
    () => expect(sha512.typeToString, equals('sha512')),
  );
  test(
    'should throw an ArgumentError if the Hash is not supported',
    () => expect(
      () => sha1.typeToString,
      throwsA(
        predicate(
          (e) => e is ArgumentError && e.message == 'Hash type not supported',
        ),
      ),
    ),
  );
}
