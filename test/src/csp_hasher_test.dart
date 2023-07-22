import 'package:crypto/crypto.dart';
import 'package:csp_hasher/src/csp_hash.dart';
import 'package:csp_hasher/src/csp_hasher.dart';
import 'package:test/test.dart';

import '../helper/load_html.dart';

void main() {
  group('getScripts()', () {
    test('Should find two scripts in sample.html', () async {
      final scripts = getScripts(loadSampleHTMLFile, HashMode.script);
      expect(scripts.length, 2);
    });

    test('Should find one style in sample.html', () async {
      final scripts = getScripts(loadSampleHTMLFile, HashMode.style);
      expect(scripts.length, 1);
    });

    test('Should find one scripts in sample_with_nonce.html', () async {
      final scripts = getScripts(loadSampleWithNonceHTMLFile, HashMode.script);
      expect(scripts.length, 1);
    });

    test('Should find no scripts in sample_with_no_scripts.html', () async {
      final scripts =
          getScripts(loadSampleHTMLWithEmptyScriptsFile, HashMode.script);
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
    group('HashMode.script', () {
      test('Sha256 Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(htmlFile: loadSampleHTMLFile);
        final hashedServiceWorkerScript = hashedScripts.first;
        expect(
          '$hashedServiceWorkerScript',
          '''"'sha256-dAtxS5kDRr7Nf5bQWvw1H9Jirf+JuUdICHgO4NZRXsA='"''',
        );
        expect(hashedServiceWorkerScript.lineNumber, 12);
        expect(hashedServiceWorkerScript.hashMode, HashMode.script);

        final hashedEventScript = hashedScripts.last;
        expect(
          '$hashedEventScript',
          '''"'sha256-QRmrLOV2cSexRDYBkk5SLrTscXMSEO218euptb/ZAww='"''',
        );
        expect(hashedEventScript.lineNumber, 28);
        expect(hashedEventScript.hashMode, HashMode.script);
      });

      test('Sha384 Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha384,
        );
        final hashedServiceWorkerScript = hashedScripts.first;
        expect(
          '$hashedServiceWorkerScript',
          '''"'sha384-izWwDGNbuH+LKeeqF084wyNMeBNvlTTBPE4q2TgaIy1cQoBoI4X1Kh66o8RSsqEC'"''',
        );
        expect(hashedServiceWorkerScript.lineNumber, 12);
        expect(hashedServiceWorkerScript.hashMode, HashMode.script);

        final hashedEventScript = hashedScripts.last;
        expect(
          '$hashedEventScript',
          '''"'sha384-XTKJ87+hhNCgHn3XdrwxZj4xRAckHUwkzIPoWLiJ8ZfY0s2EnL+zc/dhvKawcJyB'"''',
        );
        expect(hashedEventScript.lineNumber, 28);
        expect(hashedEventScript.hashMode, HashMode.script);
      });

      test('Sha512 Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha512,
        );
        final hashedServiceWorkerScript = hashedScripts.first;
        expect(
          '$hashedServiceWorkerScript',
          '''"'sha512-LUGTygeoB8sIUGBHqMmUEmPD+h/pXt1F44dpw+hpARI/sC5BRuoHqNoeIMVQ32yNlo8b5xgINyBoJ15D9RNdSA=='"''',
        );
        expect(hashedServiceWorkerScript.lineNumber, 12);
        expect(hashedServiceWorkerScript.hashMode, HashMode.script);

        final hashedEventScript = hashedScripts.last;
        expect(
          '$hashedEventScript',
          '''"'sha512-Xj/eQr122+tYblVGOUrF8Fdb1ofzONeZj4Hc+YRIYVl8IIUm0TShtYzt01pTVlRpPb7Kks9oYXZBPDMYwPLejQ=='"''',
        );
        expect(hashedEventScript.lineNumber, 28);
      });
    });
    group('HashMode.style', () {
      test('Sha256 Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashMode: HashMode.style,
        );
        expect(hashedScripts.length, 1);
        final hashedInlineStyle = hashedScripts.first;
        expect(
          '$hashedInlineStyle',
          '''"'sha256-1Wuc9zmyidfW0pJ9AMhhvd05cM2OfnK5Ovf1QsjZkRE='"''',
        );
        expect(hashedInlineStyle.lineNumber, 21);
      });

      test('Sha384 Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha384,
          hashMode: HashMode.style,
        );
        expect(hashedScripts.length, 1);
        final hashedInlineStyle = hashedScripts.first;
        expect(
          '$hashedInlineStyle',
          '''"'sha384-IOzEWlfc0Wf1jww0j8m4bU1PbSNluTRuwOeGdMdm7x7tKHKRc9upP2vYv5da7IrN'"''',
        );
        expect(hashedInlineStyle.lineNumber, 21);
      });

      test('Sha512 Should hash the scripts in the sample html', () {
        final hashedScripts = hashScripts(
          htmlFile: loadSampleHTMLFile,
          hashType: sha512,
          hashMode: HashMode.style,
        );
        expect(hashedScripts.length, 1);
        final hashedInlineStyle = hashedScripts.first;
        expect(
          '$hashedInlineStyle',
          '''"'sha512-7FUeKNR1H/JWQhnHbqq30GBu/6BCDkO0bVuF0kI1jR6Pm6YQHEF/1CSAeEARTCjHzMTRCy3/rJKedM3pIryKRQ=='"''',
        );
        expect(hashedInlineStyle.lineNumber, 21);
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
