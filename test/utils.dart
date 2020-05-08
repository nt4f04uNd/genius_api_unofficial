/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'tests.dart';

const JsonEncoder _encoderWithSpace = JsonEncoder.withIndent('  ');

/// Pretty prints json to the console.
void prettyPrintJson(Map<String, dynamic> json) {
  final prettyString = _encoderWithSpace.convert(json);
  prettyString.split('\n').forEach((element) => print(element));
}

/// Returns [GeniusApiResponse.successful] and pretty logs JSON [GeniusApiResponse.response]
///
/// This is callback to pass down to then method from API call future.
///
/// The [res] is the future result in then method.
void testLogData(GeniusApiResponse res) {
  prettyPrintJson(res.data);
}
