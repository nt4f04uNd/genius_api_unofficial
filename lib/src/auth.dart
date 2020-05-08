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

/// Implements Genius API methods for OAuth 2.0 pattern,
/// both for server and for client.
///
/// See [Genius auth docs](https://docs.genius.com/#/authentication-h1) for more info.
class GeniusApiAuth {
  /// Your application's Client ID, as listed on the
  /// [API Client management page](https://genius.com/api-clients).
  ///
  /// Used in cases when you need to authenticate the users of you application
  /// into Genius API, see [authorize].
  ///
  /// You can easily omit this if you don't need to call [authorize].
  final String clientId;

  /// Your application's Client Secret, as listed on the
  /// [API Client management page](https://genius.com/api-clients).
  ///
  /// Used to make a post query to Genius API to get the [GeniusApi.accessToken]
  /// after user authorizes with [authorize], see [token].
  ///
  /// You can easily omit this if you don't have a server and don't need to call [token].
  final String clientSecret;

  /// The URI that Genius will redirect the user to after they've authorized in your application.
  /// It must be the same as the one set for the API client on [management page](https://genius.com/api-clients).
  ///
  /// Must be provided if you use will use either [authorize] or [token]
  final Uri redirectUri;

  /// Default constructor.
  ///
  /// The `redirectUri` in the constructor can be either a [String] or a [Uri].
  @Deprecated(
      "Prefer using named constructors instead of it as there's no actual reason to specify together both [clientId] and [clientSecret]")
  GeniusApiAuth({
    this.clientId,
    this.clientSecret,
    dynamic redirectUri,
  }) : redirectUri = checkUri(redirectUri);

  /// Creates an auth object for client usage.
  /// See [authorize].
  ///
  /// The `redirectUri` in the constructor can be either a [String] or a [Uri].
  GeniusApiAuth.client({@required this.clientId, @required dynamic redirectUri})
      : redirectUri = checkUri(redirectUri),
        clientSecret = null,
        assert(clientId != null && redirectUri != null);

  /// Creates an auth object for the server usage.
  /// See [token].
  ///
  /// The `redirectUri` in the constructor can be either a [String] or a [Uri].
  GeniusApiAuth.server(
      {@required this.clientSecret, @required dynamic redirectUri})
      : redirectUri = checkUri(redirectUri),
        clientId = null,
        assert(clientSecret != null && redirectUri != null);

  /// Constructs the Uri to redirect the user of your application to Genius's authentication page.
  ///
  /// It allows you to open this Uri by your self, because this part is very platform-dependent.
  /// Example of usage with [openUrlOnDesktop] is implemented in [authorize] method.
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

    return Uri.https(GeniusApi.baseUrl, 'oauth/authorize', {
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
    try {
      return openUrlOnDesktop(constructAuthorize(
        scope: scope,
        state: state,
        responseType: responseType,
      ).toString());
    } catch (error) {
      throw Exception(
          'You are not on a desktop platform. Consider using `constructAuthorize` method instead to get the redirect Uri and open it manually.');
    }
  }

  /// Exchanges code query parameter from the redirect after using [authorize] to the actual [GeniusApi.accessToken]
  /// by making a POST request.
  ///
  /// This method is intended to be used on server side, so internally it requires
  /// [clientSecret] and [redirectUri] to be defined on class creation.
  ///
  /// Using this on client-side is dangerous and pointless as you will expose your [clientSecret].
  ///
  /// [code] is code query parameter from the redirect to your [redirectUri] in [authorize].
  ///
  /// Throws [GeniusApiException] ([GeniusApiException.apiRequest] will be null).
  Future<void> token(String code) async {
    assert(clientSecret != null,
        "You haven't specified [clientSecret] for using this method");

    final res = await http.post(
      Uri.https(GeniusApi.baseUrl, 'oauth/token', {
        'code': code,
        'client_secret': clientSecret,
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'redirect_uri': redirectUri.toString(),
        'response_type': GeniusApiAuthResponseType.code.stringValue,
      }),
    );
    final json = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json['access_token'];
    } else {
      var message;
      if (json['meta'] != null) {
        message = json['meta']['message'];
      }
      throw GeniusApiException(
        statusCode: res.statusCode,
        httpErrorPhrase: res.reasonPhrase,
        message: message,
        detailedType: json['error'],
        detailedDescription: json['error_description'],
      );
    }
  }
}

/// The scopes that restrict what Genius API methods you can access with the [GeniusApi.accessToken].
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
