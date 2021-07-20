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

  final api = GeniusApiRaw(
    accessToken: config.accessTokenUserAll,
    defaultOptions: GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
  );

  //****************** Annotation tests ************************
  group(
    'Annotations |',
    () {
      /// Will be gotten from the call of [GeniusApiRaw.postCreateAnnotation].
      int annotationId;

      test(
        'Create annotation',
        () async {
          expect(
            await api
                .postCreateAnnotation(
              annotationMarkdown: 'TEST ANNOTATION',
              referentRawAnnotatableUrl: Uri.parse(
                'https://seejohncode.com/2014/01/27/vim-commands-piping/',
              ),
              referentFragment: 'execute commands',
              referentBeforeHtml: 'You may know that you can ',
              referentAfterHtml: ' from inside of vim, with a vim command:',
              webPageTitle: 'Secret of Mana',
              options: GeniusApiOptions(textFormat: GeniusApiTextFormat.html),
            )
                .then((res) {
              annotationId = res.data['annotation']['id'];
              return res;
            }),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test('Get created annotation', () async {
        expect(
          await api.getAnnotation(annotationId),
          isA<GeniusApiResponse>(),
          skip: skipExpect,
        );
      }, skip: skipTest);

      test(
        'Updated created annotation',
        () async {
          expect(
            await api.putUpdateAnnotation(
              annotationId,
              annotationMarkdown: 'TEST ANNOTATION CHANGED',
              referentRawAnnotatableUrl: Uri.parse(
                'https://seejohncode.com/2014/01/27/vim-commands-piping/',
              ),
              referentFragment: 'execute commands',
              referentBeforeHtml: 'You may know that you can ',
              referentAfterHtml: ' from inside of vim, with a vim command:',
              webPageTitle: 'Secret of Mana',
              options: GeniusApiOptions(textFormat: GeniusApiTextFormat.html),
            ),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Delete created annotation',
        () async {
          expect(
            await api.deleteAnnotation(annotationId),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Upvote some annotation',
        () async {
          expect(
            // Upvotes "https://genius.com/15378201" annotation.
            await api.putUpvoteAnnotation(15378201),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Downvote some annotation',
        () async {
          expect(
            // Downvotes "https://genius.com/15378201" annotation.
            await api.putDownvoteAnnotation(15378201),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Remove vote from some annotation',
        () async {
          expect(
            // Removes votes from "https://genius.com/15378201" annotation.
            await api.putUnvoteAnnotation(15378201),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );

  //****************** Referents tests ************************
  group(
    'Referents |',
    () {
      test(
        'Get referent by createdById only',
        () async {
          expect(
            // Gets referents created by "https://genius.com/nt4f04uNd".
            await api.getReferents(createdById: 10357192),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Get referent by songId only',
        () async {
          expect(
            // Gets referents on song "https://genius.com/Yxngxr1-riley-reid-lyrics"
            await api.getReferents(songId: 4585202),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Get referent by songId with createdById',
        () async {
          expect(
            // Gets referents on song "https://genius.com/Yxngxr1-riley-reid-lyrics" created by "https://genius.com/yngshady"
            await api.getReferents(songId: 4585202, createdById: 7703702),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Get referent by webPageId only',
        () async {
          expect(
            // Gets referents on webpage "https://docs.genius.com".
            await api.getReferents(webPageId: 10347),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Get referent by webPageId with createdById',
        () async {
          expect(
            // Gets referents on webpage "https://docs.genius.com" created by "https://genius.com/driptonite".
            await api.getReferents(webPageId: 10347, createdById: 3191803),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );

  //****************** Songs tests ************************
  group(
    'Songs |',
    () {
      test(
        'Get song',
        () async {
          expect(
            // Gets "https://genius.com/Yxngxr1-riley-reid-lyrics".
            await api.getSong(4585202),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );

  //****************** Artists tests ************************
  group(
    'Artists |',
    () {
      test(
        'Get artist',
        () async {
          expect(
            // Gets "https://genius.com/artists/Yxngxr1".
            await api.getArtist(1697628),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );

      test(
        'Get artist songs',
        () async {
          expect(
            // Gets "https://genius.com/artists/Yxngxr1" songs.
            await api.getArtistSongs(1697628),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );

  //****************** Webpage tests ************************
  group(
    'Webpage |',
    () {
      test(
        'Get webpage',
        () async {
          expect(
            // Gets information about "https://docs.genius.com" webpage.
            await api.getLookupWebpages(
              rawAnnotatableUrl: Uri.parse('https://docs.genius.com'),
            ),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );

  //****************** Search tests ************************
  group(
    'Search |',
    () {
      test(
        'Search for songs',
        () async {
          expect(
            // Search for Yxngxr1 songs.
            await api.getSearch('yxngxr1'),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );

  //****************** Account tests ************************
  group(
    'Account |',
    () {
      test(
        'Get all user information',
        () async {
          expect(
            await api.getAccount(),
            isA<GeniusApiResponse>(),
            skip: skipExpect,
          );
        },
        skip: skipTest,
      );
    },
    skip: skipGroup,
  );
}
