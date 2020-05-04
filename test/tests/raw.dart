/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:test/test.dart';

import '../tests.dart';

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

  //****************** GeniusApiRaw group *****************************************************
  group(
    'GeniusApiRaw group',
    () {
      final api = GeniusApiRaw(
        auth: auth,
        defaultTextFormat: GeniusApiTextFormat.plain,
      );

      //****************** Annotation test ************************
      test(
        'Annotation test',
        () async {
          /// Will be gotten from the call of [GeniusApiRaw.postCreateAnnotation].
          int annotationId;

          //******** postCreateAnnotation ********
          expect(
            // Creates annotation.
            await api
                .postCreateAnnotation(
              annotationMarkdown: 'wowowow',
              referentRawAnnotatableUrl: Uri.parse(
                'https://seejohncode.com/2014/01/27/vim-commands-piping/',
              ),
              referentFragment: 'execute commands',
              referentBeforeHtml: 'You may know that you can ',
              referentAfterHtml: ' from inside of vim, with a vim command:',
              webPageTitle: 'Secret of Mana',
              textFormat: GeniusApiTextFormat.html,
            )
                .then((res) {
              annotationId = res.response['annotation']['id'];
              return res.successful;
            }),
            true,
            skip: skipExpect,
          );

          //******** getAnnotation ********
          expect(
            // Gets created annotation.
            await api.getAnnotation(annotationId).then(testResult),
            true,
            skip: skipExpect,
          );

          //******** putUpdateAnnotation ********
          expect(
            // Updates created annotation.
            await api
                .putUpdateAnnotation(
                  annotationId,
                  annotationMarkdown: 'wowowow_changed',
                  referentRawAnnotatableUrl: Uri.parse(
                    'https://seejohncode.com/2014/01/27/vim-commands-piping/',
                  ),
                  referentFragment: 'execute commands',
                  referentBeforeHtml: 'You may know that you can ',
                  referentAfterHtml: ' from inside of vim, with a vim command:',
                  webPageTitle: 'Secret of Mana',
                  textFormat: GeniusApiTextFormat.html,
                )
                .then(testResult),
            true,
            skip: skipExpect,
          );

          //******** deleteAnnotation ********
          expect(
            // Deletes created annotation.
            await api.deleteAnnotation(annotationId).then(testResult),
            true,
            skip: skipExpect,
          );

          //******** putUpvoteAnnotation ********
          expect(
            // Upvotes "https://genius.com/15378201" annotation.
            await api.putUpvoteAnnotation(15378201).then(testResult),
            true,
            skip: skipExpect,
          );
          //******** putDownvoteAnnotation ********
          expect(
            // Downvotes "https://genius.com/15378201" annotation.
            await api.putDownvoteAnnotation(15378201).then(testResult),
            true,
            skip: skipExpect,
          );
          //******** putUnvoteAnnotation ********
          expect(
            // Removes votes from "https://genius.com/15378201" annotation.
            await api.putUnvoteAnnotation(15378201).then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      //****************** Referents test ************************
      test(
        'Referents test',
        () async {
          //******** By createdById only ********
          expect(
            // Gets referents created by "https://genius.com/nt4f04uNd".
            await api.getReferents(createdById: 10357192).then(testResult),
            true,
            skip: skipExpect,
          );

          //******** By songId only ********
          expect(
            // Gets referents on song "https://genius.com/Yxngxr1-riley-reid-lyrics"
            await api.getReferents(songId: 4585202).then(testResult),
            true,
            skip: skipExpect,
          );

          //******** By songId with createdById ********
          expect(
            // Gets referents on song "https://genius.com/Yxngxr1-riley-reid-lyrics" created by "https://genius.com/yngshady"
            await api
                .getReferents(songId: 4585202, createdById: 7703702)
                .then(testResult),
            true,
            skip: skipExpect,
          );

          //******** By webPageId only ********
          expect(
            // Gets referents on webpage "https://docs.genius.com".
            await api.getReferents(webPageId: 10347).then(testResult),
            true,
            skip: skipExpect,
          );

          //******** By webPageId with createdById ********
          expect(
            // Gets referents on webpage "https://docs.genius.com" created by "https://genius.com/driptonite".
            await api
                .getReferents(webPageId: 10347, createdById: 3191803)
                .then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      //****************** Songs test ************************
      test(
        'Songs test',
        () async {
          expect(
            // Gets "https://genius.com/Yxngxr1-riley-reid-lyrics".
            await api.getSong(4585202).then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      //****************** Artists test ************************
      test(
        'Artists test',
        () async {
          //******** Get artist ********
          expect(
            // Gets "https://genius.com/artists/Yxngxr1".
            await api.getArtist(1697628).then(testResult),
            true,
            skip: skipExpect,
          );

          //******** Get artist songs ********
          expect(
            // Gets "https://genius.com/artists/Yxngxr1" songs.
            await api.getArtistSongs(1697628).then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      //****************** Webpage test ************************
      test(
        'Webpage test',
        () async {
          expect(
            // Gets information about "https://docs.genius.com" webpage.
            await api
                .getLookupWebpages(
                  rawAnnotatableUrl: Uri.parse('https://docs.genius.com'),
                )
                .then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      //****************** Search test ************************
      test(
        'Search test',
        () async {
          expect(
            // Search for Yxngxr1 songs.
            await api.getSearch('yxngxr1').then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      //****************** Account test ************************
      test(
        'Account test',
        () async {
          expect(
            // Get all user information.
            await api.getAccount().then(testResult),
            true,
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    // skip: skipGroup,
  );
}
