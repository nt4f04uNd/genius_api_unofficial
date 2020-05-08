/*---------------------------------------------------------------------------------------------
*  Copyright (c) nt4f04und. All rights reserved.
*  Licensed under the BSD-style license. See LICENSE in the project root for license information.
*--------------------------------------------------------------------------------------------*/

// TODO: more commets here on new, add description, use-cases, purposes and links.
// TODO: add link for pub dev on release.

/// https://dart.dev/guides/language/effective-dart/documentation#consider-writing-a-library-level-doc-comment
///
/// This library provides you a nice interface to Genius API.
/// It's not an official Genius product.
///
/// All the available [API documentation](https://docs.genius.com/) is copied
/// and adapted into comments for you to see the usage of classes/methods right from the IDE.
///
/// All the API-related classes are prefixed with `GeniusApi`.
///
/// ### Core classes:
/// * [GeniusApiOptions] allows you to configure method calls.
/// * [GeniusApiTextFormat] is the requested server response format.
/// * [GeniusApiResponse] contains the response of a successful method call.
/// * [GeniusApiException] will be thrown when http status code differs from 2xx.
///
/// ### Main API classes:
/// * [GeniusApiAuth] allows you to get an accessToken, both on server or client.
/// * [GeniusApiRaw] provides all the other officially documented methods.
/// * [GeniusApi] is basic abstract API class that you can extend to write your own implementations.
///
/// ### API implementations
///
/// I'm planning to add some more Genius API implementations in the future
/// (like `GeniusApiRawExtended` or `GeniusApiWrapped`).
///
/// There's what I think I will eventually add in new implementations:
/// * some utility methods
/// * fully typed method calls and responses
/// * [undocumented endpoints](https://github.com/shaedrich/geniusly/wiki/Undocumented-API-endpoints)
///
/// For now the library only provides the comprehensive interface to Genius API
/// through the [GeniusApiRaw] implementation, nothing more.
///
/// ### Usage example
/// ```dart
/// final api = GeniusApiRaw(
///   accessToken: 'token here',
/// // And also set all methods to return plain text instead of the default dom format.
///   defaultOptions: GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
/// );
/// 
/// // Get info about song "https://genius.com/Yxngxr1-riley-reid-lyrics".
/// final res = await api.getSong(4585202);
/// print(res.data['song']['full_title']); // Outputs "Riley Reid by ​yxngxr1"
/// 
/// ```
///
library genius_api_unofficial;

export 'src/auth.dart';
export 'src/core.dart';
export 'src/raw.dart';
export 'src/utils.dart';
