import 'package:test/test.dart';

import '../../tests.dart';
import '../auth_token_manager.dart';

// TODO: test asserts

void main() async {
  final authRedirectData = await AuthRedirectDataManager().load();

  final api = GeniusApiRaw(
    accessToken: authRedirectData?.accessToken,
    defaultOptions:
        const GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
  );

  //****************** Annotation tests ************************
  group(
    'Annotations |',
    () {
      /// Will be gotten from the call of [GeniusApiRaw.postCreateAnnotation].
      late int annotationId;

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
              options:
                  const GeniusApiOptions(textFormat: GeniusApiTextFormat.html),
            )
                .then((res) {
              annotationId = res.data!['annotation']['id'];
              return res;
            }),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test('Get created annotation', () async {
        expect(
          await api.getAnnotation(annotationId),
          isA<GeniusApiResponse>(),
        );
      });

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
              options:
                  const GeniusApiOptions(textFormat: GeniusApiTextFormat.html),
            ),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Delete created annotation',
        () async {
          expect(
            await api.deleteAnnotation(annotationId),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Upvote some annotation',
        () async {
          expect(
            // Upvotes "https://genius.com/15378201" annotation.
            await api.putUpvoteAnnotation(15378201),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Downvote some annotation',
        () async {
          expect(
            // Downvotes "https://genius.com/15378201" annotation.
            await api.putDownvoteAnnotation(15378201),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Remove vote from some annotation',
        () async {
          expect(
            // Removes votes from "https://genius.com/15378201" annotation.
            await api.putUnvoteAnnotation(15378201),
            isA<GeniusApiResponse>(),
          );
        },
      );
    },
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
          );
        },
      );

      test(
        'Get referent by songId only',
        () async {
          expect(
            // Gets referents on song "https://genius.com/Yxngxr1-riley-reid-lyrics"
            await api.getReferents(songId: 4585202),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Get referent by songId with createdById',
        () async {
          expect(
            // Gets referents on song "https://genius.com/Yxngxr1-riley-reid-lyrics" created by "https://genius.com/yngshady"
            await api.getReferents(songId: 4585202, createdById: 7703702),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Get referent by webPageId only',
        () async {
          expect(
            // Gets referents on webpage "https://docs.genius.com".
            await api.getReferents(webPageId: 10347),
            isA<GeniusApiResponse>(),
          );
        },
      );

      test(
        'Get referent by webPageId with createdById',
        () async {
          expect(
            // Gets referents on webpage "https://docs.genius.com" created by "https://genius.com/driptonite".
            await api.getReferents(webPageId: 10347, createdById: 3191803),
            isA<GeniusApiResponse>(),
          );
        },
      );
    },
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
          );
        },
      );
    },
  );

  //****************** Artists tests ************************
  group('Artists |', () {
    test(
      'Get artist',
      () async {
        expect(
          // Gets "https://genius.com/artists/Yxngxr1".
          await api.getArtist(1697628),
          isA<GeniusApiResponse>(),
        );
      },
    );

    test(
      'Get artist songs',
      () async {
        expect(
          // Gets "https://genius.com/artists/Yxngxr1" songs.
          await api.getArtistSongs(1697628),
          isA<GeniusApiResponse>(),
        );
      },
    );
  });

  //****************** Webpage tests ************************
  group('Webpage |', () {
    test(
      'Get webpage',
      () async {
        expect(
          // Gets information about "https://docs.genius.com" webpage.
          await api.getLookupWebpages(
            rawAnnotatableUrl: Uri.parse('https://docs.genius.com'),
          ),
          isA<GeniusApiResponse>(),
        );
      },
    );
  });

  //****************** Search tests ************************
  group('Search |', () {
    test(
      'Search for songs',
      () async {
        expect(
          // Search for Yxngxr1 songs.
          await api.getSearch('yxngxr1'),
          isA<GeniusApiResponse>(),
        );
      },
    );
  });

  //****************** Account tests ************************
  group('Account |', () {
    test(
      'Get all user information',
      () async {
        expect(
          await api.getAccount(),
          isA<GeniusApiResponse>(),
        );
      },
    );
  });
}
