/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:test/test.dart';

import '../config.dart';

// TODO: better tests with mocks

void main() {
  final config = TestConfig.fromJsonConfig();

  final skipGroup = config.skipGroup;
  final skipTest = config.skipTest;

  final auth = GeniusApiAuth(
    clientId: config.clientId,
    clientSecret: config.clientSecret,
    redirectUri: config.redirectUri,
  );

  group(
    'Auth constructors | ',
    () {
      test(
        'Client',
        () {
          GeniusApiAuth.client(
            clientId: config.clientId,
            redirectUri: config.redirectUri,
          );
        },
        skip: skipTest,
      );

      test(
        'Server',
        () {
          GeniusApiAuth.server(
            clientSecret: config.clientSecret,
            redirectUri:config.redirectUri,
          );
        },
      );
    },
    skip: skipGroup,
  );

  //****************** Methods group *****************************************************
  group(
    'Auth methods | ',
    () {
      //******** authorize ********
      test(
        'authorize method test',
        () async {
          await auth.authorize(
            // scope: GeniusApiAuthScope.values.toList(),
            scope: [],
            // responseType: GeniusApiAuthResponseType.token,
            responseType: GeniusApiAuthResponseType.code,
            state: 'TEST_STATE'
          );
        },
        skip: skipTest,
      );

      //******** token ********
      test(
        'token method test',
        () async {
          expect(
            await auth.token(config.exchangeCode!),
            isA<String>(),
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );
}
