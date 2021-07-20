import 'package:genius_api_unofficial/genius_api_unofficial.dart';

Future<void> main() async {
  // Create an auth object to use in client.
  final auth = GeniusApiAuth.client(
    clientId: 'your client_id here from https://genius.com/api-clients',
    redirectUri: 'your redirect_uri here from https://genius.com/api-clients',
  );

  // If you are on a desktop platform (Windows, Linux or MacOS), the browser will be opened
  // with the Genius authentication page.
  // Else you will have to use `constructAuthorize` instead to get the Uri and open it by yourself.
  await auth.authorize(
    scope: GeniusApiAuthScope.values.toList(), // Request all available scopes.
    responseType: GeniusApiAuthResponseType.token, // Get the token directly.
    // responseType: GeniusApiAuthResponseType.code, // Get the code in url to exchange it later.
  );

  // Somehow gotten the token from the Url after the authentication,
  // or you can use the client access token without authenticating users http://genius.com/api-clients
  final api = GeniusApiRaw(
    accessToken: 'token here',
    // Set all methods to return plain text instead of the default dom format.
    defaultOptions: GeniusApiOptions(textFormat: GeniusApiTextFormat.plain),
  );

  // Get info about song "https://genius.com/Yxngxr1-riley-reid-lyrics".
  final res = await api.getSong(4585202);
  print(res.data!['song']['full_title']); // Outputs "Riley Reid by ​yxngxr1"
}
