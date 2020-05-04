/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

import 'tests.dart';

import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()

/// Serializable test config
class TestConfig {
  TestConfig({
    this.accessTokenClient,
    this.accessTokenUser,
    this.accessTokenUserMe,
    this.accessTokenUserCreateAnnotation,
    this.accessTokenUserManageAnnotation,
    this.accessTokenUserVote,
    this.accessTokenUserAll,
    this.clientId,
    this.clientSecret,
    this.redirectUri,
    this.exchangeCode,
    this.skipGroup = true,
    this.skipTest = true,
    this.skipExpect = true,
  });

  /// [GeniusApiAuth.accessToken] that you get on Genius Api management page.
  final String accessTokenClient;

  /// [GeniusApiAuth.accessToken] that is user-specific (gotten from the auth methods).
  final String accessTokenUser;

  /// [GeniusApiAuth.accessToken] that is user-specific (gotten from the auth methods).
  ///
  /// Additional scopes:
  /// [GeniusApiAuthScope.me].
  final String accessTokenUserMe;

  /// [GeniusApiAuth.accessToken] that is user-specific (gotten from the auth methods).
  ///
  /// Additional scopes:
  /// [GeniusApiAuthScope.create_annotation].
  final String accessTokenUserCreateAnnotation;

  /// [GeniusApiAuth.accessToken] that is user-specific (gotten from the auth methods).
  ///
  /// Additional scopes:
  /// [GeniusApiAuthScope.manage_annotation].
  final String accessTokenUserManageAnnotation;

  /// [GeniusApiAuth.accessToken] that is user-specific (gotten from the auth methods).
  ///
  /// Additional scopes:
  /// [GeniusApiAuthScope.vote].
  final String accessTokenUserVote;

  /// [GeniusApiAuth.accessToken] that is user-specific (gotten from the auth methods).
  ///
  /// Additional scopes - all: [GeniusApiAuthScope.values].
  final String accessTokenUserAll;

  /// [GeniusApiAuth.clientId].
  final String clientId;

  /// [GeniusApiAuth.clientSecret].
  final String clientSecret;

  /// [GeniusApiAuth.redirectUri].
  final String redirectUri;

  /// Code returned in the redirected url after calling [GeniusApiAuth.authorize] method
  /// with [GeniusApiAuthResponseType.code].
  /// Can be used once in the [GeniusApiAuth.token].
  final String exchangeCode;

  /// Variable to configure test skipping,
  /// every [group] should include this.
  /// This allows to disable all [group]s in some group except one or some.
  final bool skipGroup;

  /// Same as [skipGroup] but for [test]s.
  final bool skipTest;

  /// Same as [skipGroup] but for [expect]s.
  final bool skipExpect;

  /// Constructs object from JSON map.
  factory TestConfig.fromJson(Map<String, dynamic> json) =>
      _$TestConfigFromJson(json);

  /// Gets object from the JSON file config.
  /// 
  /// The [configUri] is the path to the config file.
  /// Defaults to `Uri.file('test/config.json', windows: true)`, 
  /// that means that it is in the same dir as this class.
  factory TestConfig.fromJsonConfig({Uri configUri}) {
    configUri ??= Uri.file('test/config.json', windows: true);
    return TestConfig.fromJson(
      jsonDecode(File.fromUri(configUri).readAsStringSync()),
    );
  }
}