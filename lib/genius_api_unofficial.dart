// TODO: update this doc comment on each release.

/// This library provides you with a nice interface to Genius API.
/// *It's not an official Genius product*.
///
/// All the available [API documentation](https://docs.genius.com/) is copied
/// and adapted into comments for you to see the usage of classes/methods right from an IDE.
///
/// All the API-related classes are prefixed with `GeniusApi`.
///
/// ## Classes
///
/// ### Core classes
/// * [GeniusApiOptions] allows you to configure method calls.
/// * [GeniusApiTextFormat] is the requested server response format.
/// * [GeniusApiResponse] contains the response of a successful method call.
/// * [GeniusApiException] will be thrown when http status code differs from 2xx.
///
/// ### Main API classes
/// * [GeniusApiAuth] allows you to get an accessToken, both on server or client.
/// * [GeniusApiRaw] provides all the other officially documented methods.
/// * [GeniusApi] is basic abstract API class that you can extend to create your own implementations.
///
/// ## Plans
///
/// I'm planning to add some more Genius API implementations in the future
/// (like `GeniusApiRawExtended` or `GeniusApiWrapped`).
///
/// There's what I think I will eventually add in new implementations:
///
/// * some utility methods
/// * fully typed method calls and responses
/// * [undocumented endpoints](https://github.com/shaedrich/geniusly/wiki/Undocumented-API-endpoints)
///
/// For now the library only provides the comprehensive interface to Genius API
/// through the `GeniusApiRaw` implementation, nothing more.
///
/// ## Usage
///
/// Each method is documented fairly well and has pretty the same parameters, as listed
/// in the official API doc.
///
/// You can find usage examples for each of them in [tests folder](https://github.com/nt4f04uNd/genius_api_unofficial/tree/master/test/tests).
///
/// A simple usage example:
///
/// ```dart
/// final api = GeniusApiRaw(
///   accessToken: 'token here',
/// // Set all methods to return plain text instead of the default dom format.
///   defaultOptions: GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
/// );
///
/// // Get info about song "https://genius.com/Yxngxr1-riley-reid-lyrics".
/// final res = await api.getSong(4585202);
/// print(res.data!['song']['full_title']); // Outputs "Riley Reid by ​yxngxr1"
/// ```
///
/// ## Links
///
/// * [GitHub repository](https://github.com/nt4f04uNd/genius_api_unofficial)
///
library;

export 'src/auth.dart';
export 'src/core.dart';
export 'src/raw.dart';
