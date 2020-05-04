/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:test/test.dart';

import '../config.dart';

void main() {
  final config = TestConfig.fromJsonConfig();

  final skipGroup = config.skipGroup;
  final skipTest = config.skipTest;
  final skipExpect = config.skipExpect;

  final auth = GeniusApiAuth(
    accessToken: config.accessTokenUserAll,
    clientId: config.clientId,
    clientSecret: config.clientSecret,
    redirectUri: Uri.parse(config.redirectUri),
  );

  //****************** Auth group *****************************************************
  group(
    'Auth group',
    () {
      // setUp(() {});

      // test('General stuff test', () {
      //   expect(GeniusApiAuthScope.me.stringValue, "me");
      // });

      //******** authorize ********
      test(
        'authorize method test',
        () async {
          await auth.authorize(
            // scope: GeniusApiAuthScope.values.toList(),
            scope: [],
            responseType: GeniusApiAuthResponseType.token,
            // responseType: GeniusApiAuthResponseType.code,
          );
        },
        skip: skipTest,
      );

      //******** token ********
      test(
        'token method test',
        () async {
          await auth.token(config.exchangeCode);
          expect(auth.accessToken != null, true, skip: skipExpect);
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );
}
