import 'dart:io';

void main(List<String> args) async {
  List<String> testFiles = [
    'test/integration/tests/auth_test.dart',
    'test/integration/tests/raw_test.dart',
  ];

  for (var testFile in testFiles) {
    print('Running $testFile...');
    final process = await Process.start('flutter', ['test', testFile, ...args]);

    process.stdout.transform(SystemEncoding().decoder).listen((data) {
      print(data);
    });

    process.stderr.transform(SystemEncoding().decoder).listen((data) {
      print(data);
    });

    var exitCode = await process.exitCode;
    if (exitCode != 0) {
      print('Test failed in $testFile');
      exit(exitCode);
    } else {
      print('Test passed in $testFile');
    }
  }
}
