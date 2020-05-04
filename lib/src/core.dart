/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';
import 'raw.dart';

/// The base url of Genius API.
const String geniusApiBaseUrl = 'api.genius.com';
const String geniusApiBaseUrlUndocumented = 'genius.com/api';

/// TODO: docs
///
/// TODO: about naming conventions
abstract class GeniusApi {
  /// The auth instance to authenticate API calls.
  final GeniusApiAuth auth;

  /// The default format of all Genius API responses is [dom].
  final GeniusApiTextFormat defaultTextFormat;

  GeniusApi({
    this.auth,
    this.defaultTextFormat,
  });

  /// Makes a call to API, gets the response JSON and wraps it with [GeniusApiResponse].
  /// Generally not for public usage, as this is very base method.
  Future<GeniusApiResponse> makeRequest(
    GeniusApiRequest request,
  ) async {
    final res = await request.call();
    Map<String, dynamic> json;
    if (res.statusCode != 204) {
      json = jsonDecode(res.body);
    }
    return GeniusApiResponse(
      status: res.statusCode,
      errorMessage: json != null ? json['meta']['message'] : null,
      response: json != null ? json['response'] : null,
      textFormat: request.textFormat,
      textFormatApplicable: request.textFormatApplicable,
    );
  }
}

typedef HttpCallback = Future<http.Response> Function();

/// Describes a call to Genius API.
/// Generally not for public usage.
///
/// Passed to [GeniusApi.makeRequest].
class GeniusApiRequest {
  GeniusApiRequest({
    @required this.textFormat,
    this.textFormatApplicable = true,
    @required this.call,
  }) : assert(call != null);

  /// Requested text format. See [GeniusApiResponse.textFormat].
  /// If [textFormatApplicable] is `false`, explicitly specify it as `null`.
  final GeniusApiTextFormat textFormat;

  /// Whether the [textFormat] is applicable for this method call.
  /// Defaults to `true`.
  final bool textFormatApplicable;

  /// Function that performs a call to the API.
  final HttpCallback call;
}

/// Represents the base of resulting response for any call to Genius API
/// (except [GeniusApiAuth] methods).
class GeniusApiResponse {
  GeniusApiResponse({
    @required this.status,
    @required this.errorMessage,
    @required this.response,
    @required this.textFormat,
    @required this.textFormatApplicable,
  }) : assert(status != null && textFormatApplicable != null);

  /// The HTTP request status code.
  /// Cannot be `null`.
  final int status;

  /// Error message for unsuccessful requests.
  /// Equals to `null` for successful requests.
  final String errorMessage;

  /// The text format that was requested from the server.
  ///
  /// Can be `null` in the following cases:
  /// 1. textFormat was not configured in API object, and method that can accept this parameter was called without it.
  ///  In this case text format will be default, that is for now [GeniusApiTextFormat.dom].
  /// 2. textFormat is not applicable for this method call and [textFormatApplicable] is `true`.
  final GeniusApiTextFormat textFormat;

  /// Whether the [textFormat] was applicable for this method call.
  /// Defaults to `true`.
  final bool textFormatApplicable;

  /// The actual data returned by API.
  /// Equals to `null` for unsuccessful requests (or if [status] is `204` - "No content").
  final Map<String, dynamic> response;

  /// Checks if the result of the request is successful.
  ///
  /// Performs checks both of `status` and `errorMessage`
  bool get successful => status >= 200 && status < 300 && errorMessage == null;

  @override
  String toString() =>
      'GeniusApiResponse: {status: $status, errorMessage: $errorMessage, textFormat: ${textFormat.stringValue}, textFormatApplicable: $textFormatApplicable, response: ${response == null ? null : "jsonData..."}}';
}

/// The format of returned Genius API data.
///
/// The default format of all Genius API responses is [dom].
///
/// Many API requests accept a text_format query parameter
/// that can be used to specify how text content is formatted.
/// The value for the parameter must be one or more of [plain], [html], and [dom].
enum GeniusApiTextFormat {
  /// Just plain text, no markup.
  plain,

  /// String of unescaped HTML suitable for rendering by a browser.
  html,

  /// Nested object representing and HTML DOM hierarchy that can be used to programmatically.
  dom
}

/// Extension to serialize the value of [GeniusApiTextFormat].
extension GeniusApiTextFormatStringValue on GeniusApiTextFormat {
  /// Returns a string with the value of enum.
  String get stringValue {
    if (this == null) return 'null';
    return toString().substring('GeniusApiTextFormat.'.length);
  }
}

/// A sort feature. Used in [GeniusApiRaw.getArtistSongs] method.
/// Default for the API is [title].
enum GeniusApiSort { title, popularity }

/// Extension to serialize the value of [GeniusApiSort].
extension GeniusApiSortStringValue on GeniusApiSort {
  /// Returns a string with the value of enum.
  String get stringValue {
    if (this == null) return 'null';
    return toString().substring('GeniusApiSort.'.length);
  }
}
