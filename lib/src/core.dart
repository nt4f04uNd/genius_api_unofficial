/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';
import 'raw.dart';

/// [Uri] creation helper.
///
/// Will parse the URI string or return the [Uri] as it is.
Uri checkUri(dynamic uri) => uri is String ? Uri.parse(uri) : uri;

/// All http methods.
enum HttpMethod {
  get,
  post,
  head,
  put,
  delete,
  connect,
  options,
  trace,
  patch,
}

/// Extension to serialize the value of [HttpMethod].
extension HttpMethodStringValue on HttpMethod {
  /// Returns a string with the value of enum (in upper-case).
  String get stringValue {
    if (this == null) return 'null';
    return toString().substring('HttpMethod.'.length).toUpperCase();
  }
}

/// Represents a single call to Genius API.
class GeniusApiRequest {
  GeniusApiRequest({
    @required this.method,
    @required this.uri,
    @required this.options,
    this.json,
    this.authorized = true,
    this.textFormatApplicable = true,
  })  : assert(method != null),
        assert(uri != null),
        assert(options != null),
        assert(authorized != null),
        assert(textFormatApplicable != null) {
    if (!textFormatApplicable) {
      options.textFormat = null;
    }
  }

  /// The http method.
  final HttpMethod method;

  /// Source URI, can be either a [Uri] or a [String].
  dynamic uri;

  /// The body data of the request.
  ///
  /// This contains data before encoding it to JSON for [http.Request].
  final dynamic json;

  /// Whether the method call is authorized with [GeniusApi.accessToken].
  final bool authorized;

  /// Whether the [GeniusApiTextFormat] is applicable for this method call.
  /// Defaults to `true`.
  ///
  /// It makes option [GeniusApiOptions.textFormat] null if true.
  final bool textFormatApplicable;

  /// Call options for this request, will override [GeniusApi.defaultOptions].
  GeniusApiOptions options;
}

/// Options that will be applied for the API calls.
class GeniusApiOptions {
  GeniusApiOptions({
    this.timeout,
    this.textFormat,
  });

  /// Creates default API options.
  GeniusApiOptions.def()
      : timeout = Duration(minutes: 2),
        textFormat = null;

  /// The maximum duration that a single request can be performed.
  Duration timeout;

  /// The text format requested from the server.
  ///
  /// Can be `null` in the following cases:
  ///
  /// 1. It is not configured, and method that can accept this parameter is called without it.
  ///  In this case returned from the Genius API server text format will be default,
  ///  that is currently [GeniusApiTextFormat.dom].
  /// 2. It is not applicable for the method call, because [GeniusApiRequest.textFormatApplicable] is `true`.
  ///
  GeniusApiTextFormat textFormat;

  /// Creates a copy of these API options but with the given fields replaced with
  /// the new values from other instance.
  GeniusApiOptions copyWith(GeniusApiOptions other) {
    assert(other != null);
    return GeniusApiOptions(
      timeout: other.timeout ?? timeout,
      textFormat: other.textFormat ?? textFormat,
    );
  }
}

// TODO: add new implementations here when they will be written
/// The base for any Genius API implementation.
///
/// The implementations (only one for now):
/// * [GeniusApiRaw] - Basic Genius API implementation which contains all the endpoints listed in the official documentation.
abstract class GeniusApi {
  /// Creates an API object.
  ///
  /// * More info about accessToken: [GeniusApi.accessToken].
  /// * More info about defaultOptions: [GeniusApi.defaultOptions].
  GeniusApi({
    this.accessToken,
    GeniusApiOptions defaultOptions,
  }) {
    final defOptions = GeniusApiOptions.def();
    if (defaultOptions == null) {
      this.defaultOptions = defOptions;
    } else {
      this.defaultOptions = defOptions.copyWith(defaultOptions);
    }
  }

  /// The official base url of Genius API.
  static String baseUrl = 'api.genius.com';

  /// The http client.
  final http.Client _client = http.Client();

  /// A bearer token used to access all other Genius API methods.
  ///
  /// Most of the Genius API methods are authenticated with it.
  ///
  /// It can be omitted, though you won't be able to call methods that require it.
  ///
  /// There are two types of access tokens:
  /// 1. ***User-specific*** - to get them, you have to use [GeniusApiAuth.authorize]
  /// and also, depending on whether your application client-only, or not, [GeniusApiAuth.token].
  /// 2. ***Client access token*** - see below.
  ///
  /// If your application doesn't include user-specific behaviors you can use
  /// the client access token associated with your API instead of tokens for authenticated users.
  /// These tokens are only valid for read-only endpoints that are not restricted by a
  /// [required scope](https://docs.genius.com/#/available-scopes).
  ///
  /// You can get a client access token by clicking "Generate Access Token" on the
  /// [API Client management page](https://genius.com/api-clients).
  final String accessToken;

  /// Default API options that will be used on every API call (unless you override them for a single API call).
  ///
  /// If omitted, will be initialized with [GeniusApiOptions.def()].
  GeniusApiOptions defaultOptions;

  /// Returns [defaultOptions] if [options] is null,
  /// or overrides [defaultOptions] with the new values from [options] argument and returns them.
  GeniusApiOptions combineOptions(GeniusApiOptions options) =>
      options == null ? defaultOptions : defaultOptions.copyWith(options);

  /// Shortcut for the [HttpMethod.get] call.
  Future<GeniusApiResponse> get(
    dynamic uri,
    GeniusApiOptions options, {
    dynamic json,
    bool authorized = true,
    bool textFormatApplicable = true,
  }) =>
      send(GeniusApiRequest(
        method: HttpMethod.get,
        uri: uri,
        authorized: authorized,
        json: json,
        options: options,
        textFormatApplicable: textFormatApplicable,
      ));

  /// Shortcut for the [HttpMethod.post] call.
  Future<GeniusApiResponse> post(
    dynamic uri,
    GeniusApiOptions options, {
    dynamic json,
    bool authorized = true,
    bool textFormatApplicable = true,
  }) =>
      send(GeniusApiRequest(
        method: HttpMethod.post,
        uri: uri,
        authorized: authorized,
        json: json,
        options: options,
        textFormatApplicable: textFormatApplicable,
      ));

  /// Shortcut for the [HttpMethod.put] call.
  Future<GeniusApiResponse> put(
    dynamic uri,
    GeniusApiOptions options, {
    dynamic json,
    bool authorized = true,
    bool textFormatApplicable = true,
  }) =>
      send(GeniusApiRequest(
        method: HttpMethod.put,
        uri: uri,
        authorized: authorized,
        json: json,
        options: options,
        textFormatApplicable: textFormatApplicable,
      ));

  /// Shortcut for the [HttpMethod.delete] call.
  Future<GeniusApiResponse> delete(
    dynamic uri,
    GeniusApiOptions options, {
    dynamic json,
    bool authorized = true,
    bool textFormatApplicable = true,
  }) =>
      send(GeniusApiRequest(
        method: HttpMethod.delete,
        uri: uri,
        authorized: authorized,
        json: json,
        options: options,
        textFormatApplicable: textFormatApplicable,
      ));

  /// Makes a call to the API, gets the response JSON and wraps it with [GeniusApiResponse] on success
  /// or else throws [GeniusApiException].
  ///
  /// Generally, not for public usage, as this is very basic method.
  ///
  /// The [apiRequest] is the description of the API request.
  ///
  /// This method doesn't takes care about matching [GeniusApiRequest.options] to the [defaultOptions],
  /// this must be a work of a caller.
  /// [defaultOptions] only will be used if [GeniusApiRequest.options] is `null`.
  Future<GeniusApiResponse> send(GeniusApiRequest apiRequest) async {
    apiRequest.uri = checkUri(apiRequest.uri);
    apiRequest.options ??= defaultOptions;
    final httpRequest =
        http.Request(apiRequest.method.stringValue, apiRequest.uri);
    if (apiRequest.authorized) {
      httpRequest.headers['Authorization'] = 'Bearer ${accessToken}';
    }
    if (apiRequest.json != null) {
      httpRequest.headers['Content-Type'] = 'application/json';
      httpRequest.body = jsonEncode(apiRequest.json);
    }

    http.Response res;
    await Future(() async {
      final streamedResponse = await _client.send(httpRequest);
      res = await http.Response.fromStream(streamedResponse);
    }).timeout(apiRequest.options.timeout);

    Map<String, dynamic> responseJson;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.statusCode != 204) {
        // Calling this with empty res.body when 204 will cause FormatException
        responseJson = jsonDecode(res.body);
      }
      return GeniusApiResponse(
        apiRequest: apiRequest,
        statusCode: res.statusCode,
        data: responseJson != null ? responseJson['response'] : null,
      );
    } else {
      responseJson = jsonDecode(res.body);
      var message;
      if (responseJson['meta'] != null) {
        message = responseJson['meta']['message'];
      }
      throw GeniusApiException(
        apiRequest: apiRequest,
        statusCode: res.statusCode,
        httpErrorPhrase: res.reasonPhrase,
        message: message,
        detailedType: responseJson['error'],
        detailedDescription: responseJson['error_description'],
      );
    }
  }
}

/// Represents a result of a method call.
abstract class GeniusApiResult {
  GeniusApiResult(this.apiRequest);

  /// An API call object.
  ///
  /// Its [GeniusApiRequest.uri] will be always [Uri].
  final GeniusApiRequest apiRequest;
}

/// Represents the base of a resulting response for any successful call to Genius API
/// (except [GeniusApiAuth] methods).
///
/// See also [GeniusApiException] that will be thrown for unsuccessful calls to the API.
class GeniusApiResponse implements GeniusApiResult {
  GeniusApiResponse({
    @required this.statusCode,
    @required this.data,
    @required this.apiRequest,
  }) : assert(statusCode != null);

  /// The HTTP request status code.
  /// Cannot be `null`.
  final int statusCode;

  /// The actual data returned by the API.
  /// Equals to `null` if [statusCode] is `204` - "No content".
  final Map<String, dynamic> data;

  /// An API call object.
  /// Its [GeniusApiRequest.uri] will be always [Uri].
  @override
  final apiRequest;

  @override
  String toString() =>
      'GeniusApiResponse: [status] $statusCode | [data] ${data == null ? null : "data..."} | [apiRequest] apiRequest...';
}

/// Exception being thrown when Genius API responses with codes not in range of 2xx.
class GeniusApiException implements Exception, GeniusApiResult {
  GeniusApiException({
    @required this.statusCode,
    this.apiRequest,
    this.httpErrorPhrase,
    this.message,
    this.detailedType,
    this.detailedDescription,
  }) : assert(statusCode != null);

  final int statusCode;

  /// An API call object.
  /// Its [GeniusApiRequest.uri] will be always [Uri].
  ///
  /// Equals to `null` when thrown out of [GeniusApiAuth.token].
  @override
  final apiRequest;

  final String httpErrorPhrase;

  /// Message contained in the "meta" "message" field of a Genius API response (if present).
  final String message;

  /// Message contained in the "error" field of a Genius API response (if present).
  final String detailedType;

  /// Message contained in the "error_description" field of a Genius API response (if present).
  final String detailedDescription;

  @override
  String toString() =>
      'GeniusApiException: ($statusCode) [message] $message | [httpErrorPhrase] $httpErrorPhrase | [detailedType] $detailedType | [detailedDescription] $detailedDescription | [apiRequest] apiRequest...';
}

/// The format of returned Genius API data.
///
/// The default format of all Genius API responses is [dom].
///
/// Many API methods accept a textFormat query parameter
/// that can be used to specify how response text content is formatted.
/// The value for the parameter must be one or more of [plain], [html], and [dom].
enum GeniusApiTextFormat {
  /// Just plain text, no markup.
  plain,

  /// String of unescaped HTML suitable for rendering by a browser.
  html,

  /// Nested object representing and HTML DOM hierarchy that
  /// can be used to programmatically present structured content.
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

/// A sort feature.
/// Used in [GeniusApiRaw.getArtistSongs] method.
/// The default for the API is [title].
enum GeniusApiSort { title, popularity }

/// Extension to serialize the value of [GeniusApiSort].
extension GeniusApiSortStringValue on GeniusApiSort {
  /// Returns a string with the value of enum.
  String get stringValue {
    if (this == null) return 'null';
    return toString().substring('GeniusApiSort.'.length);
  }
}
