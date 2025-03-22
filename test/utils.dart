import 'tests.dart';

const JsonEncoder _encoderWithSpace = JsonEncoder.withIndent('  ');

/// Pretty prints JSON to the console.
void prettyPrintJson(Map<String, dynamic>? json) {
  final prettyString = _encoderWithSpace.convert(json);
  prettyString.split('\n').forEach((element) => print(element));
}

/// Logs JSON data from [GeniusApiResponse.data].
///
/// This is callback to pass down to then method from an API call future.
///
/// The [res] is the future result in then method.
void testLogData(GeniusApiResponse res) {
  prettyPrintJson(res.data);
}
