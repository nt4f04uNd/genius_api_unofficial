/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'dart:convert';
import 'dart:io';

import 'core.dart';
import 'utils.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

/// Implements Genius API oauth pattern,
/// both for server and for client.
///
/// See [Genius auth docs](https://docs.genius.com/#/authentication-h1) for more info.
class GeniusApiAuth {
  String _accessToken;

  /// A bearer token used to access all other Genius API methods.
  ///
  /// All requests to Genius API are authenticated with it.
  ///
  /// There are two types of access tokens:
  /// 1. ***User-specific*** - to get them, you have to use [authorize]
  /// and also, depending on whether your application client-only, or not, [token].
  /// 2. ***Client access token*** - see below.
  ///
  /// If your application doesn't include user-specific behaviors you can use
  /// the client access token associated with your API instead of tokens for authenticated users.
  /// These tokens are only valid for read-only endpoints that are not restricted by a
  /// [required scope](https://docs.genius.com/#/available-scopes).
  ///
  /// You can get a client access token by clicking "Generate Access Token" on the
  /// [API Client management page](https://genius.com/api-clients).

  String get accessToken {
    if (_accessToken == null) {
      // TODO: remove it or make it dev/debug-only
      print(
          'WARNING! You are calling accessToken getter when the accessToken is null. Have you set up GeniusApiAuth?');
    }
    return _accessToken;
  }

  set accessToken(value) => _accessToken = value;

  /// Your application's Client ID, as listed on the
  /// [API Client management page](https://genius.com/api-clients).
  ///
  /// Used in cases when you need to authenticate the users of you application
  /// into Genius API, see [authorize].
  ///
  /// You can easily omit this if you don't need to call [authorize].
  String clientId;

  /// Your application's Client Secret, as listed on the
  /// [API Client management page](https://genius.com/api-clients).
  ///
  /// Used to make a post query to Genius API to get the [accessToken]
  /// after user authorizes with [authorize], see [token].
  ///
  /// You can easily omit this if you don't have a server and don't need to call [token].
  String clientSecret;

  /// The URI that Genius will redirect the user to after they've authorized in your application.
  /// It must be the same as the one set for the API client on [management page](https://genius.com/api-clients).
  ///
  /// Must be provided if you use will use either [authorize] or [token]
  Uri redirectUri;

  /// Default constructor.
  /// Shouldn't ever be used as there's no actual reason to specify together
  /// all [accessToken], [clientId] and [clientSecret].
  ///
  /// If you specify [clientId] or [clientSecret], the [redirectUri] also must be provided.
  GeniusApiAuth({
    String accessToken,
    this.clientId,
    this.clientSecret,
    this.redirectUri,
  })  : _accessToken = accessToken,
        assert(accessToken != null ||
            (clientId != null || clientSecret != null) && redirectUri != null);

  /// Creates an auth object from available [accessToken].
  ///
  /// Convenient to use it for client access tokens - when you don't need to auth the user,
  /// though also can be used if you have somehow already gotten user-specific access token.
  GeniusApiAuth.fromAccessToken({@required String accessToken})
      : _accessToken = accessToken,
        assert(accessToken != null);

  /// Creates an auth object for client usage.
  /// See [authorize].
  GeniusApiAuth.client({@required this.clientId, @required this.redirectUri})
      : assert(clientId != null && redirectUri != null);

  /// Creates an auth object for the server usage.
  /// See [token].
  GeniusApiAuth.server(
      {@required this.clientSecret, @required this.redirectUri})
      : assert(clientSecret != null && redirectUri != null);

  /// Constructs the Uri to redirect the user of your application to Genius's authentication page.
  ///
  /// It allows you to open this Uri by your self, because this part is very platform-dependent.
  /// Example of usage with [openUrlDesktop] is implemented in [authorize] method.
  /// Note that just requesting this method by https GET is pointless, as it returns HTML page.
  ///
  /// On the authentication page the user can choose to allow your application to access Genius on their behalf.
  /// They'll be asked to sign in (or, if necessary, create an account) first.
  ///
  /// This method is intended to be used on client side, so internally it requires
  /// [clientId] and [redirectUri] to be defined on class creation.
  ///
  /// [scope] is the permissions your application is requesting as a space-separated list
  /// (see [GeniusApiAuthScope]).
  /// By default method will only query [GeniusApiAuthScope.me] scope.
  ///
  /// [state] is a required value that will be returned with the code redirect for
  /// maintaining arbitrary state through the authorization process.
  /// Defaults to empty string.
  ///
  /// [responseType] - controls the url the user will be redirected after authentication process.
  /// Defaults value is [GeniusApiAuthResponseType.code].
  ///
  /// If responseType equals to [GeniusApiAuthResponseType.code],
  /// then the user is redirected to `https://YOUR_REDIRECT_URI/?code=CODE&state=SOME_STATE_VALUE`.
  ///
  /// Your application can exchange the code query parameter from the redirect for an access token by calling [token].
  ///
  /// Else if responseType equals to [GeniusApiAuthResponseType.token],
  /// this enables an alternative authentication flow is available for browser-based, client-only applications.
  /// This mechanism is much less secure than the full code exchange process and should only be used
  /// by applications without a server or native platform to execute the full code flow.
  /// Instead of being redirected with a code that your application exchanges for an access token,
  /// the user is redirected to `https://REDIRECT_URI/#access_token=ACCESS_TOKEN&state=STATE`.
  /// Extract the access token from the URL hash fragment and use it to make requests.
  ///
  /// With the token response type, the user's access token is exposed in the browser,
  /// where it could be accessed by malicious JavaScript or otherwise intercepted
  /// much more easily than when it's only exchanged between servers.
  /// The client secret isn't used, so it's much easier for potential attackers to fake authorization requests.
  /// Don't use the token flow if you don't have to.
  Uri constructAuthorize({
    List<GeniusApiAuthScope> scope = const [GeniusApiAuthScope.me],
    String state,
    GeniusApiAuthResponseType responseType = GeniusApiAuthResponseType.code,
  }) {
    assert(clientId != null,
        "You haven't specified [clientId] for using this method");

    return Uri.https(geniusApiBaseUrl, 'oauth/authorize', {
      'client_id': clientId,
      'redirect_uri': redirectUri.toString(),
      'scope': scope
          .fold<String>('', (value, el) => value + el.stringValue + ' ')
          .trimRight(),
      'state': state,
      'response_type': responseType.stringValue,
    });
  }

  /// Function to implement to use the URI from [constructAuthorize], opens browser on desktop platforms by default.
  ///
  /// See [constructAuthorize] for the full description.
  Future<ProcessResult> authorize({
    List<GeniusApiAuthScope> scope = const [GeniusApiAuthScope.me],
    String state,
    GeniusApiAuthResponseType responseType = GeniusApiAuthResponseType.code,
  }) {
    return openUrlDesktop(constructAuthorize(
      scope: scope,
      state: state,
      responseType: responseType,
    ).toString());
  }

  /// Exchanges code query parameter from the redirect after using [authorize] to the actual [accessToken]
  /// by making a POST request.
  ///
  /// This method is intended to be used on server side, so internally it requires
  /// [clientSecret] and [redirectUri] to be defined on class creation.
  ///
  /// Using this on client-side is dangerous and pointless as you will expose your [clientSecret].
  ///
  /// [code] is code query parameter from the redirect to your [redirectUri] in [authorize].
  ///
  /// Throws [AuthTokenMethodException] if gets `error` field in the response.
  Future<void> token(String code) async {
    assert(clientSecret != null,
        "You haven't specified [clientSecret] for using this method");

    final res = await http.post(
      Uri.https(geniusApiBaseUrl, 'oauth/token', {
        'code': code,
        'client_secret': clientSecret,
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'redirect_uri': redirectUri.toString(),
        'response_type': GeniusApiAuthResponseType.code.stringValue,
      }),
    );
    final json = jsonDecode(res.body);
    if (json['error'] != null) {
      throw AuthTokenMethodException(
        type: json['error'],
        description: json['error_description'],
      );
    } else {
      accessToken = json['access_token'];
    }
  }
}

/// The scopes that restrict what Genius API methods you can access with the [GeniusApiAuth.accessToken].
///
/// Access tokens can only be used for resources that
/// are covered by the scopes provided when they created,
/// these are the available scopes.
///
/// See [available scopes](https://docs.genius.com/#/available-scopes) on Api doc page.
enum GeniusApiAuthScope {
  /// Endpoint
  /// ```
  /// GET /account
  /// ```
  me,

  /// Endpoint
  /// ```
  /// POST /annotations
  /// ```
  create_annotation,

  /// Endpoints
  /// ```
  /// PUT /annotations/:id
  /// DELETE /annotations/:id
  /// ```
  manage_annotation,

  /// Endpoints
  /// ```
  /// PUT /annotations/:id/upvote
  /// PUT /annotations/:id/downvote
  /// PUT /annotations/:id/unvote
  /// ```
  vote,
}

/// For [GeniusApiAuth.authorize] responseType parameter.
///
/// For more info see [GeniusApiAuth.constructAuthorize].
enum GeniusApiAuthResponseType {
  /// The user will be redirected to `https://YOUR_REDIRECT_URI/?code=CODE&state=SOME_STATE_VALUE`.
  code,

  /// The user will be  redirected to `https://REDIRECT_URI/#access_token=ACCESS_TOKEN&state=STATE`.
  token
}

/// Extension to serialize the value of [GeniusApiAuthScope].
extension GeniusApiAuthScopeStringValue on GeniusApiAuthScope {
  /// Returns a string with the value of enum
  String get stringValue {
    if (this == null) return 'null';
    return toString().substring('GeniusApiAuthScope.'.length);
  }
}

/// Extension to serialize the value of [GeniusApiAuthResponseType].
extension GeniusApiAuthResponseTypeStringValue on GeniusApiAuthResponseType {
  /// Returns a string with the value of enum.
  String get stringValue {
    if (this == null) return 'null';
    return toString().substring('GeniusApiAuthResponseType.'.length);
  }
}

/// The exception thrown when the method [GeniusApiAuth.token] gets an error in response.
/// 
/// This is the only thrown error, because the the failure of the [GeniusApiAuth.token]
/// method is totally wrong from the point of view of the implementation.
class AuthTokenMethodException implements Exception {
  final String type;
  final String description;
  AuthTokenMethodException({this.type, this.description});
  @override
  String toString() =>
      "Auth token method error of type '$type'\ndescription: $description";
}