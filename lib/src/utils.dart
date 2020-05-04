/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'dart:io';

/// Opens URl in browser if dart is running in any desktop environment.
Future<ProcessResult> openUrlDesktop(String url) async {
  if (Platform.isWindows) {
    // These ' ' needed because arguments parsers won't embed double quotation marks in command line.
    return Process.run('start', [' ', url + ' '], runInShell: true);
  } else if (Platform.isLinux) {
    return Process.run('x-www-browser', [url]);
  } else if (Platform.isMacOS) {
    return Process.run('open', [url]);
  } else {
    throw Exception("Couldn't open url in browser: not a desktop platform");
  }
}