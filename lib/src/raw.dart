/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'dart:convert';

import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';

/// TODO: docs
class GeniusApiRaw extends GeniusApi {
  /// The auth instance to authenticate API calls.
  @override
  final GeniusApiAuth auth;

  /// The default format of all Genius API responses is [dom].
  @override
  final GeniusApiTextFormat defaultTextFormat;

  GeniusApiRaw({
    this.auth,
    this.defaultTextFormat,
  });

  /// Gets data for a specific annotation.
  ///
  /// An annotation is a piece of content about a part of a document.
  /// The document may be a song (hosted on Genius) or a web page (hosted anywhere).
  /// The part of a document that an annotation is attached to is called a referent.
  ///
  /// Annotation data returned from the API includes both the substance of the annotation
  /// and the necessary information for displaying it in its original context.
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getAnnotation(
    int id, {
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, 'annotations/${id}', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Creates a new annotation on a public web page.
  ///
  /// Requires scope: [GeniusApiAuthScope.create_annotation].
  ///
  /// The returned value will be the new annotation object,
  /// in the same form as would be returned by [getAnnotation] with the new annotation's ID.
  ///
  /// The names of the parameters are not original and short-cut for convenience.
  /// For the original doc see "POST /annotations" on [https://docs.genius.com/](Genius Api reference).
  ///
  /// At least one of the [webPageCanonicalUrl], [webPageOgUrl] or [webPageTitle] is required.
  ///
  /// The [annotationMarkdown] is the text for the note, in markdown.
  ///
  /// The [referentRawAnnotatableUrl] is the original URL of the page.
  ///
  /// The [referentFragment] is the highlighted fragment.
  ///
  /// The [referentBeforeHtml] is the HTML before the highlighted fragment (prefer up to 200 characters).
  ///
  /// The [referentAfterHtml] is the highlighted fragment.
  ///
  /// The [webPageCanonicalUrl] is the href property of the `<link rel="canonical">` tag on the page.
  /// Including it will help make sure newly created annotation appear on the correct page.
  ///
  /// The [webPageOgUrl] is the `content` property of the `<meta property="og:url">` tag on the page.
  /// Including it will help make sure newly created annotation appear on the correct page.
  ///
  /// The [webPageTitle] is the title of the page.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response
  /// (this is not mentioned for some reason in official docs).
  Future<GeniusApiResponse> postCreateAnnotation({
    @required String annotationMarkdown,
    @required Uri referentRawAnnotatableUrl,
    @required String referentFragment,
    String referentBeforeHtml,
    String referentAfterHtml,
    Uri webPageCanonicalUrl,
    Uri webPageOgUrl,
    String webPageTitle,
    GeniusApiTextFormat textFormat,
  }) async {
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.post(
          Uri.https(geniusApiBaseUrl, 'annotations'),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
            'Content-Type': 'application/json',
          },
          body: _constructAnnotationRequestBody(
            annotationMarkdown,
            referentRawAnnotatableUrl,
            referentFragment,
            referentBeforeHtml,
            referentAfterHtml,
            webPageCanonicalUrl,
            webPageOgUrl,
            webPageTitle,
            textFormat,
          ),
        ),
      ),
    );
  }

  /// Updates an annotation created by the authenticated user.
  /// Accepts the same parameters as [postCreateAnnotation], except [id].
  ///
  /// Requires scope: [GeniusApiAuthScope.manage_annotation].
  ///
  /// The returned value will be the new annotation object,
  /// in the same form as would be returned by [getAnnotation] with the new annotation's ID.
  ///
  /// The names of the parameters are not original and short-cut for convenience.
  /// For the original doc see "POST /annotations" on [https://docs.genius.com/](Genius Api reference).
  ///
  /// At least one of the [webPageCanonicalUrl], [webPageOgUrl] or [webPageTitle] is required.
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// The [annotationMarkdown] is the text for the note, in markdown.
  ///
  /// The [referentRawAnnotatableUrl] is the original URL of the page.
  ///
  /// The [referentFragment] is the highlighted fragment.
  ///
  /// The [referentBeforeHtml] is the HTML before the highlighted fragment (prefer up to 200 characters).
  ///
  /// The [referentAfterHtml] is the highlighted fragment.
  ///
  /// The [webPageCanonicalUrl] is the href property of the `<link rel="canonical">` tag on the page.
  /// Including it will help make sure newly created annotation appear on the correct page.
  ///
  /// The [webPageOgUrl] is the `content` property of the `<meta property="og:url">` tag on the page.
  /// Including it will help make sure newly created annotation appear on the correct page.
  ///
  /// The [webPageTitle] is the title of the page.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response
  Future<GeniusApiResponse> putUpdateAnnotation(
    int id, {
    @required String annotationMarkdown,
    @required Uri referentRawAnnotatableUrl,
    @required String referentFragment,
    String referentBeforeHtml,
    String referentAfterHtml,
    Uri webPageCanonicalUrl,
    Uri webPageOgUrl,
    String webPageTitle,
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.put(
          Uri.https(geniusApiBaseUrl, 'annotations/${id}'),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
            'Content-Type': 'application/json',
          },
          body: _constructAnnotationRequestBody(
            annotationMarkdown,
            referentRawAnnotatableUrl,
            referentFragment,
            referentBeforeHtml,
            referentAfterHtml,
            webPageCanonicalUrl,
            webPageOgUrl,
            webPageTitle,
            textFormat,
          ),
        ),
      ),
    );
  }

  /// Deletes an annotation created by the authenticated user.
  ///
  /// Requires scope: [GeniusApiAuthScope.manage_annotation].
  ///
  /// This method returns empty body on success, unlike other annotation methods.
  /// That's why it doesn't have textFormat parameter.
  ///
  /// The [id] is the ID of the annotation.
  Future<GeniusApiResponse> deleteAnnotation(int id) async {
    assert(id != null);
    return makeRequest(
      GeniusApiRequest(
        textFormat: null,
        textFormatApplicable: false,
        call: () => http.delete(
          Uri.https(geniusApiBaseUrl, 'annotations/${id}'),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Votes positively for the annotation on behalf of the authenticated user.
  ///
  /// Requires scope: [GeniusApiAuthScope.vote].
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> putUpvoteAnnotation(
    int id, {
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.put(
          Uri.https(geniusApiBaseUrl, 'annotations/${id}/upvote', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Votes negatively for the annotation on behalf of the authenticated user.
  ///
  /// Requires scope: [GeniusApiAuthScope.vote].
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> putDownvoteAnnotation(
    int id, {
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.put(
          Uri.https(geniusApiBaseUrl, 'annotations/${id}/downvote', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Removes the authenticated user's vote (up or down) for the annotation.
  ///
  /// Requires scope: [GeniusApiAuthScope.vote].
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> putUnvoteAnnotation(
    int id, {
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.put(
          Uri.https(geniusApiBaseUrl, 'annotations/${id}/unvote', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Creates http request body for [postCreateAnnotation] and [putUpdateAnnotation] methods.
  ///
  /// Returns JSON string, so header `Content-Type` has to be set to `application/json`
  String _constructAnnotationRequestBody(
    String annotationMarkdown,
    Uri referentRawAnnotatableUrl,
    String referentFragment,
    String referentBeforeHtml,
    String referentAfterHtml,
    Uri webPageCanonicalUrl,
    Uri webPageOgUrl,
    String webPageTitle,
    GeniusApiTextFormat textFormat,
  ) {
    assert(
      annotationMarkdown != null &&
          referentRawAnnotatableUrl != null &&
          referentFragment != null,
      'These are required parameters',
    );
    assert(
      webPageCanonicalUrl != null ||
          webPageOgUrl != null ||
          webPageTitle != null,
      'At least one required: webPageCanonicalUrl, webPageOgUrl or webPageTitle',
    );
    return jsonEncode({
      if (textFormat != null) 'text_format': textFormat.stringValue,
      'annotation': {
        'body': {
          'markdown': annotationMarkdown,
        }
      },
      'referent': {
        'raw_annotatable_url': referentRawAnnotatableUrl.toString(),
        'fragment': referentFragment,
        if (referentBeforeHtml != null || referentAfterHtml != null)
          'context_for_display': {
            if (referentBeforeHtml != null) 'before_html': referentBeforeHtml,
            if (referentAfterHtml != null) 'after_html': referentAfterHtml,
          }
      },
      'web_page': {
        if (webPageCanonicalUrl != null)
          'canonical_url': webPageCanonicalUrl.toString(),
        if (webPageOgUrl != null) 'og_url': webPageOgUrl.toString(),
        if (webPageTitle != null) 'title': webPageTitle,
      },
    });
  }

  /// Gets referents by content item or user responsible for an included annotation.
  ///
  /// Must supply at least one: [songId], [webPageId], or [createdById].
  ///
  /// Also, you may pass only one of [songId] and [webPageId], not both.
  ///
  /// Referents are the sections of a piece of content to which annotations are attached.
  /// Each referent is associated with a web page or a song and may have one or more annotations.
  /// Referents can be searched by the document they are attached to or by the user that created them.
  ///
  /// When a new annotation is created either a referent is created with it
  /// or that annotation is attached to an existing referent.
  ///
  /// The [createdById] is the ID of a user to get referents for.
  ///
  /// The [songId] is the ID of a song to get referents for.
  ///
  /// The [webPageId] is the ID of a web page to get referents for.
  ///
  /// The [perPage] is number of results to return per request.
  ///
  /// The [page] is a paginated offset (for example, `perPage=5` and `page=3` returns songs 11–15).
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getReferents({
    int createdById,
    int songId,
    int webPageId,
    int perPage,
    int page,
    GeniusApiTextFormat textFormat,
  }) async {
    assert(
      createdById != null || songId != null || webPageId != null,
      'Must supply songId, webPageId, or createdById',
    );
    assert(
      songId == null || webPageId == null,
      'Cannot search for both a web page and song',
    );
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, 'referents', {
            if (createdById != null) 'created_by_id': createdById.toString(),
            if (songId != null) 'song_id': songId.toString(),
            if (webPageId != null) 'web_page_id': webPageId.toString(),
            if (perPage != null) 'per_page': perPage.toString(),
            if (page != null) 'page': page.toString(),
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Gets data for a specific song.
  ///
  /// A song is a document hosted on Genius. It's usually music lyrics.
  ///
  /// Data for a song includes details about the document itself and information
  /// about all the referents that are attached to it, including the text to which they refer.
  ///
  /// The [id] is the ID of a song.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getSong(
    int id, {
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, 'songs/${id}', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Gets data for a specific artist.
  ///
  /// An artist is how Genius represents the creator of one or more songs (or other documents hosted on Genius).
  /// It's usually a musician or group of musicians.
  ///
  /// The [id] is the ID of the artist.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getArtist(
    int id, {
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, 'artists/${id}', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Gets documents (songs) for the specified artist.
  /// By default, 20 items are returned for each request.
  ///
  /// The [id] is the ID of the artist.
  ///
  /// The [sort] defaults to null, though for the API it defaults to [GeniusApiSort.title].
  ///
  /// The [perPage] is number of results to return per request.
  ///
  /// The [page] is a paginated offset (for example, `perPage=5` and `page=3` returns songs 11–15).
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getArtistSongs(
    int id, {
    GeniusApiSort sort,
    int perPage,
    int page,
    GeniusApiTextFormat textFormat,
  }) async {
    assert(id != null);
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, 'artists/${id}/songs', {
            if (sort != null) 'sort': sort.stringValue,
            if (perPage != null) 'per_page': perPage.toString(),
            if (page != null) 'page': page.toString(),
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Gets information about a web page retrieved by the page's full URL (including protocol).
  ///
  /// A web page is a single, publicly accessible page to which annotations may be attached.
  /// Web pages map 1-to-1 with unique, canonical URLs.
  ///
  /// The returned data includes Genius's ID for the page,
  /// which may be used to look up associated referents with the [getReferents] method.
  ///
  /// Data is only available for pages that already have at least one annotation.
  ///
  /// Provide as many of the following variants of the URL as possible:
  ///
  /// The [rawAnnotatableUrl] is the URL as it would appear in a browser.
  ///
  /// The [canonicalUrl] is the URL as specified by an appropriate `<link>` tag in a page's `<head>`.
  ///
  /// The [ogUrl] is the URL as specified by an `og:url <meta>` tag in a page's `<head>`.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getLookupWebpages({
    Uri rawAnnotatableUrl,
    Uri canonicalUrl,
    Uri ogUrl,
    GeniusApiTextFormat textFormat,
  }) async {
    assert(
      rawAnnotatableUrl != null || canonicalUrl != null || ogUrl != null,
      'Specify at least one url to lookup a webpage',
    );
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, '/web_pages/lookup', {
            if (rawAnnotatableUrl != null)
              'raw_annotatable_url': rawAnnotatableUrl.toString(),
            if (canonicalUrl != null) 'canonical_url': canonicalUrl.toString(),
            if (ogUrl != null) 'og_url': ogUrl.toString(),
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Searches for songs. The search capability covers all content hosted on Genius (all songs).
  ///
  /// The [query] is the term to search for.
  Future<GeniusApiResponse> getSearch(String query) async {
    return makeRequest(
      GeniusApiRequest(
        textFormat: null,
        textFormatApplicable: false,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, '/search', {
            if (query != null) 'q': query,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }

  /// Gets user account information.
  ///
  /// Account information includes general contact information and Genius-specific details about a user.
  ///
  /// The [textFormat] is the [GeniusApiTextFormat] for the response.
  Future<GeniusApiResponse> getAccount({
    GeniusApiTextFormat textFormat,
  }) async {
    textFormat ??= defaultTextFormat;
    return makeRequest(
      GeniusApiRequest(
        textFormat: textFormat,
        call: () => http.get(
          Uri.https(geniusApiBaseUrl, '/account', {
            if (textFormat != null) 'text_format': textFormat.stringValue,
          }),
          headers: {
            'Authorization': 'Bearer ${auth.accessToken}',
          },
        ),
      ),
    );
  }
}
