import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;

// Loading the sample.html file
File get loadSampleHTMLFile => File('test/test_resources/sample.html');

Document get loadSampleHTML => parse(loadSampleHTMLString);

String get loadSampleHTMLString => loadSampleHTMLFile.readAsStringSync();

// Loading the sample_with_nonce.html file
File get loadSampleWithNonceHTMLFile =>
    File('test/test_resources/sample_with_nonce.html');

Document get loadSampleWithNonceHTML => parse(loadSampleWithNonceHTMLString);

String get loadSampleWithNonceHTMLString =>
    loadSampleWithNonceHTMLFile.readAsStringSync();

// Loading the sample_with_empty_scripts.html file
File get loadSampleHTMLWithEmptyScriptsFile =>
    File('test/test_resources/sample_with_empty_scripts.html');

Document get loadSampleHTMLWithEmptyScripts =>
    parse(loadSampleHTMLWithEmptyScriptsString);

String get loadSampleHTMLWithEmptyScriptsString =>
    loadSampleHTMLWithEmptyScriptsFile.readAsStringSync();
