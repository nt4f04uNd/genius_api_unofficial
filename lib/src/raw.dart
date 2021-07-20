/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:meta/meta.dart';

import 'auth.dart';

/// Basic Genius API implementation which contains all the endpoints
/// listed in the official documentation.
///
/// Any method call always returns [GeniusApiResponse] with a map response data on success,
/// or throws [GeniusApiException] if some error occured.
class GeniusApiRaw extends GeniusApi {
  /// Creates an API object.
  ///
  /// * More info about accessToken: [GeniusApi.accessToken].
  /// * More info about defaultOptions: [GeniusApi.defaultOptions].
  GeniusApiRaw({
    String accessToken,
    GeniusApiOptions defaultOptions,
  }) : super(
          accessToken: accessToken,
          defaultOptions: defaultOptions,
        );

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
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getAnnotation(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, 'annotations/$id', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
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
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> postCreateAnnotation({
    @required String annotationMarkdown,
    @required Uri referentRawAnnotatableUrl,
    @required String referentFragment,
    String referentBeforeHtml,
    String referentAfterHtml,
    Uri webPageCanonicalUrl,
    Uri webPageOgUrl,
    String webPageTitle,
    GeniusApiOptions options,
  }) async {
    options = combineOptions(options);
    return post(
      Uri.https(GeniusApi.baseUrl, 'annotations'),
      options,
      json: _constructAnnotationRequestBody(
        annotationMarkdown,
        referentRawAnnotatableUrl,
        referentFragment,
        referentBeforeHtml,
        referentAfterHtml,
        webPageCanonicalUrl,
        webPageOgUrl,
        webPageTitle,
        options.textFormat,
      ),
    );
  }

  /// Updates an annotation created by the authenticated user.
  /// Accepts the same parameters as [postCreateAnnotation], except the [id].
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
  /// [options] are the new call options to override [defaultOptions] for this request.
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
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return put(
      Uri.https(GeniusApi.baseUrl, 'annotations/$id'),
      options,
      json: _constructAnnotationRequestBody(
        annotationMarkdown,
        referentRawAnnotatableUrl,
        referentFragment,
        referentBeforeHtml,
        referentAfterHtml,
        webPageCanonicalUrl,
        webPageOgUrl,
        webPageTitle,
        options.textFormat,
      ),
    );
  }

  /// Deletes an annotation created by the authenticated user.
  ///
  /// Requires scope: [GeniusApiAuthScope.manage_annotation].
  ///
  /// This method returns empty body on success, unlike other annotation methods,
  /// that's why it doesn't have textFormat parameter.
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> deleteAnnotation(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return delete(
      Uri.https(GeniusApi.baseUrl, 'annotations/$id'),
      options,
      textFormatApplicable: false,
    );
  }

  /// Votes positively for the annotation on behalf of the authenticated user.
  ///
  /// Requires scope: [GeniusApiAuthScope.vote].
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> putUpvoteAnnotation(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return put(
      Uri.https(GeniusApi.baseUrl, 'annotations/$id/upvote', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
    );
  }

  /// Votes negatively for the annotation on behalf of the authenticated user.
  ///
  /// Requires scope: [GeniusApiAuthScope.vote].
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> putDownvoteAnnotation(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return put(
      Uri.https(GeniusApi.baseUrl, 'annotations/$id/downvote', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
    );
  }

  /// Removes the authenticated user's vote (up or down) for the annotation.
  ///
  /// Requires scope: [GeniusApiAuthScope.vote].
  ///
  /// The [id] is the ID of the annotation.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> putUnvoteAnnotation(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return put(
      Uri.https(GeniusApi.baseUrl, 'annotations/$id/unvote', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
    );
  }

  /// Creates http request body for the [postCreateAnnotation] and [putUpdateAnnotation] methods.
  Map<String, dynamic> _constructAnnotationRequestBody(
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
    return {
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
    };
  }

  /// Gets referents by content item or user responsible for an included annotation.
  ///
  /// Must supply at least one: [songId], [webPageId], or [createdById].
  ///
  /// Also, you may pass only one of the [songId] and [webPageId], not both.
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
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getReferents({
    int createdById,
    int songId,
    int webPageId,
    int perPage,
    int page,
    GeniusApiOptions options,
  }) async {
    assert(
      createdById != null || songId != null || webPageId != null,
      'Must supply songId, webPageId, or createdById',
    );
    assert(
      songId == null || webPageId == null,
      'Cannot search for both a web page and song',
    );
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, 'referents', {
        if (createdById != null) 'created_by_id': createdById.toString(),
        if (songId != null) 'song_id': songId.toString(),
        if (webPageId != null) 'web_page_id': webPageId.toString(),
        if (perPage != null) 'per_page': perPage.toString(),
        if (page != null) 'page': page.toString(),
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
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
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getSong(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, 'songs/$id', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
    );
  }

  /// Gets data for a specific artist.
  ///
  /// An artist is how Genius represents the creator of one or more songs (or other documents hosted on Genius).
  /// It's usually a musician or group of musicians.
  ///
  /// The [id] is the ID of the artist.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getArtist(
    int id, {
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, 'artists/$id', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
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
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getArtistSongs(
    int id, {
    GeniusApiSort sort,
    int perPage,
    int page,
    GeniusApiOptions options,
  }) async {
    assert(id != null);
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, 'artists/$id/songs', {
        if (sort != null) 'sort': sort.stringValue,
        if (perPage != null) 'per_page': perPage.toString(),
        if (page != null) 'page': page.toString(),
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
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
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getLookupWebpages({
    Uri rawAnnotatableUrl,
    Uri canonicalUrl,
    Uri ogUrl,
    GeniusApiOptions options,
  }) async {
    assert(
      rawAnnotatableUrl != null || canonicalUrl != null || ogUrl != null,
      'Specify at least one url to lookup a webpage',
    );
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, '/web_pages/lookup', {
        if (rawAnnotatableUrl != null)
          'raw_annotatable_url': rawAnnotatableUrl.toString(),
        if (canonicalUrl != null) 'canonical_url': canonicalUrl.toString(),
        if (ogUrl != null) 'og_url': ogUrl.toString(),
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
    );
  }

  /// Searches for songs. The search capability covers all content hosted on Genius (all songs).
  ///
  /// The [query] is the term to search for.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getSearch(
    String query, {
    GeniusApiOptions options,
  }) async {
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, '/search', {
        if (query != null) 'q': query,
      }),
      options,
      textFormatApplicable: false,
    );
  }

  /// Gets user account information.
  ///
  /// Account information includes general contact information and Genius-specific details about a user.
  ///
  /// [options] are the new call options to override [defaultOptions] for this request.
  Future<GeniusApiResponse> getAccount({
    GeniusApiOptions options,
  }) async {
    options = combineOptions(options);
    return get(
      Uri.https(GeniusApi.baseUrl, '/account', {
        if (options.textFormat != null)
          'text_format': options.textFormat.stringValue,
      }),
      options,
    );
  }
}
