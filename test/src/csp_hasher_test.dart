import 'package:crypto/crypto.dart';
import 'package:csp_hasher/src/csp_hasher.dart';
import 'package:test/test.dart';

import '../helper/load_html.dart';

void main() {
  group('getScripts()', () {
    test('Should find three scripts in sample.html', () async {
      final scripts = getScripts(loadSampleHTMLFile);
      expect(scripts.length, 2);
    });

    test('Should find three scripts in sample.html', () async {
      final scripts = getScripts(loadSampleWithNonceHTMLFile);
      expect(scripts.length, 1);
    });

    test('Should find no scripts in sample_with_no_scripts.html', () async {
      final scripts = getScripts(loadSampleHTMLWithEmptyScriptsFile);
      expect(scripts.length, 0);
    });
  });

  group('hashScripts', () {
    test('Should throw if a non supported HashType is inserted', () {
      expect(
        () => hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha224,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
    test('Should return an empty list if there are no scripts', () {
      final hashedScripts = hashScripts(
        htmlFile: loadSampleHTMLWithEmptyScriptsFile,
      );
      expect(hashedScripts, isEmpty);
    });
    group('Sha256', () {
      test('Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(htmlFile: loadSampleHTMLFile);
        final hashedServiceWorkerScript = hashedScripts.first;
        expect(
          '$hashedServiceWorkerScript',
          '''"'sha256-DYE2F9R1zqzhJwChIaBDWw4p1FtYuRhkYTCsJwEni1o='"''',
        );
        expect(hashedServiceWorkerScript.lineNumber, 35);

        final hashedEventScript = hashedScripts.last;
        expect(
          '$hashedEventScript',
          '''"'sha256-7kkT0t17vF4Bgf54wBSjuZO3pORc3aibNdISkVdNrnk='"''',
        );
        expect(hashedEventScript.lineNumber, 43);
      });
    });
    group('Sha384', () {
      test('Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha384,
        );
        final hashedServiceWorkerScript = hashedScripts.first;
        expect(
          '$hashedServiceWorkerScript',
          '''"'sha384-SXUxNfAG3vW81Xqzlv28ndONmqQezL+RnITpGhbuXcJPpx5JW2grzy8hGK3h8/JS'"''',
        );
        expect(hashedServiceWorkerScript.lineNumber, 35);

        final hashedEventScript = hashedScripts.last;
        expect(
          '$hashedEventScript',
          '''"'sha384-LIj/+KEHaedkn1bv3oYh05IeZDmbgFA68WbaYYokwK2S7zqFMy8JimN1ciBngTJx'"''',
        );
        expect(hashedEventScript.lineNumber, 43);
      });
    });
    group('Sha512', () {
      test('Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha512,
        );
        final hashedServiceWorkerScript = hashedScripts.first;
        expect(
          '$hashedServiceWorkerScript',
          '''"'sha512-PT8zhJrdQWDWlmFD0JnXQNhhhcSaWv2QkYJQR0e0/bpMRXQjFdmrHUCt2VD/F3ODSSkAymTk7U+Ioke6Mz2O/A=='"''',
        );
        expect(hashedServiceWorkerScript.lineNumber, 35);

        final hashedEventScript = hashedScripts.last;
        expect(
          '$hashedEventScript',
          '''"'sha512-8G4uS0MdZrs5ptGyDN5bhZbOqsESg6ZMyM1KOcBiorhrmFiCHOWqXShljGD7dO3E40EeyPlq3os5ureB5EBZRA=='"''',
        );
        expect(hashedEventScript.lineNumber, 43);
      });
    });
  });
  group('getLineNumber', () {
    test('returns the correct line number', () {
      const htmlFile =
          'line 1\nline 2\n<script>console.log("hello");</script>\nline 4\n';
      const script = '<script>console.log("hello");</script>';
      expect(getLineNumber(htmlFile, script), equals(3));
    });

    test('returns 1 for an empty file', () {
      const htmlFile = '';
      const script = '<script>console.log("hello");</script>';
      expect(getLineNumber(htmlFile, script), equals(1));
    });

    test('returns 1 for a file without the script', () {
      const htmlFile = 'line 1\nline 2\nline 3\nline 4\n';
      const script = '<script>console.log("hello");</script>';
      expect(getLineNumber(htmlFile, script), equals(1));
    });

    test('handles \\r\\n line endings correctly', () {
      const htmlFile =
          'line 1\r\nline 2\r\n<script>console.log("hello");</script>\r\nline 4\r\n';
      const script = '<script>console.log("hello");</script>';
      expect(getLineNumber(htmlFile, script), equals(3));
    });
  });
}
