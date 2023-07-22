# Example

By default `csp_hasher` will hash scripts tags in the given html with `sha256`

## Example 1

```dart
import 'dart:io';
import 'package:csp_hasher/csp_hasher.dart';

void main() {
    final cspHashes = hashScripts(File('mySuperNice.html'));
    print(cspHashes.first); // sha256-<hash>
    print(cspHashes.first.hash); // The base64 encoded hash
    print(cspHashes.first.hashType); // The hash type which is sha256 by default
    print(cspHashes.first.lineNumber); // Gives you the line number of the script tag in the html
    print(cspHashes.first.hashMode); // Gives you type which can be style or script
}
```

## Example 2

If you want to change the hash type you can do so by passing the `hashType` parameter to the `hashScripts` function.

```dart
import 'dart:io';
import 'package:csp_hasher/csp_hasher.dart';

void main() {
    final cspHashes = hashScripts(File('mySuperNice.html'), hashType: sha384);
    print(cspHashes.first); // sha384-<hash>

    final cspHashes = hashScripts(File('mySuperNice.html'), hashType: sha512);
    print(cspHashes.first); // sha512-<hash>
}
```

## Example 3

If you want to hash style tags you can do so by passing the `hashMode` parameter to the `hashScripts` function.

```dart
import 'dart:io';
import 'package:csp_hasher/csp_hasher.dart';

void main() {
    final cspHashes = hashScripts(File('mySuperNice.html', hashMode: HashMode.style);
    print(cspHashes.first.hashMode); // HashMode.style
}
```
