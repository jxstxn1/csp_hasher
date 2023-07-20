import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:csp_hasher/src/csp_hash.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

/// Hashes all the scripts in the html file
/// Returns a list of [CspHash]
/// If there are no scripts, it returns an empty list
/// `hashType` is the type of hash to use (sha256, sha384, sha512)
/// `htmlFile` is the html file to hash
/// Ignores scripts with a nonce attribute
///
/// Example:
/// ```html
/// <script src="main.dart" nonce="abc123"></script> // will be ignored
/// ```
///
/// Example:
/// ```html
/// <script src="main.dart"></script> // will be hashed
/// ```
///
/// ```dart
/// final htmlFile = File('index.html');
/// final hashes = hashScripts(hashType: sha256, htmlFile: htmlFile);
/// ```
List<CspHash> hashScripts({
  required File htmlFile,
  Hash hashType = sha256,
}) {
  assert(hashType == sha256 || hashType == sha384 || hashType == sha512);
  // getting all the scripts from the html file
  final scripts = getScripts(htmlFile);
  if (scripts.isEmpty) {
    return [];
  }

  // hashing the scripts
  return hasher(scripts, hashType);
}

/// Get all the scripts from the html file
Map<int, String> getScripts(File htmlFile) {
  // reading html file as string
  final htmlString = htmlFile.readAsStringSync();

  // parsing the html file into a document
  final Document htmlDocumentFile = parse(htmlString);
  final hashScripts = <int, String>{};
  final List<Element> scripts = [
    ...htmlDocumentFile.getElementsByTagName('script'),
    ...htmlDocumentFile.getElementsByTagName('style')
  ];
  for (final script in scripts) {
    if (!script.attributes.containsKey('nonce')) {
      final scriptString = script.innerHtml;
      // Only adding the script if it is not empty
      // Example: <script></script>
      if (scriptString.isNotEmpty) {
        hashScripts.addAll(
          {getLineNumber(htmlString, scriptString): scriptString},
        );
      }
    }
  }
  return hashScripts;
}

List<CspHash> hasher(
  Map<int, String> scripts,
  Hash hashType,
) {
  final hashScripts = <CspHash>[];
  scripts.forEach((lineNumber, script) {
    if (script.isNotEmpty) {
      // Hasing the UTF-8 encoded script
      final hashedScriptBytes = hashType.convert(utf8.encode(script)).bytes;
      // Encoding the hashed script to base64
      final base64String = base64.encode(hashedScriptBytes);
      // Adding the hashed script to the list
      // The format is '<HashType>-<base64String>'
      // Example: 'sha256-<base64String>'
      hashScripts.add(
        CspHash(
          lineNumber: lineNumber,
          hashType: hashType,
          hash: base64String,
        ),
      );
    }
  });
  return hashScripts;
}

/// Returns the line number of the script in the html file
int getLineNumber(String htmlFile, String script) {
  const slashN = 0x0A;
  const slashR = 0x0D;

  int lineStarts = 0;
  final length = htmlFile.indexOf(script);
  for (var i = 0; i < length; i++) {
    final unit = htmlFile.codeUnitAt(i);
    // Special-case \r\n.
    if (unit == slashR) {
      // Peek ahead to detect a following \n.
      if (i + 1 < length && htmlFile.codeUnitAt(i + 1) == slashN) {
        // Line start will get registered at next index at the \n.
      } else {
        lineStarts++;
      }
    }
    // \n
    if (unit == slashN) {
      lineStarts++;
    }
  }

  return lineStarts + 1;
}
