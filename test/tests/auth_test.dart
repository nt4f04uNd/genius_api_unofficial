import 'package:genius_api_unofficial/genius_api_unofficial.dart';
import 'package:test/test.dart';

// TODO: better tests with mocks

void main() {
  group('Auth constructors | ', () {
    test('Client', () {
      const clientId = 'clientId';
      const redirectUri = 'example.com';
      final api = GeniusApiAuth.client(
        clientId: clientId,
        redirectUri: redirectUri,
      );
      expect(api.clientId, clientId);
      expect(api.redirectUri, Uri.parse(redirectUri));
      expect(api.clientSecret, null);
    });

    test('Client with URI', () {
      const clientId = 'clientId';
      final redirectUri = Uri.parse('example.com');
      final api = GeniusApiAuth.client(
        clientId: clientId,
        redirectUri: redirectUri,
      );
      expect(api.clientId, clientId);
      expect(api.redirectUri, redirectUri);
      expect(api.clientSecret, null);
    });

    test('Server', () {
      const clientSecret = 'clientSecret';
      const redirectUri = 'example.com';
      final api = GeniusApiAuth.server(
        clientSecret: clientSecret,
        redirectUri: redirectUri,
      );
      expect(api.clientId, null);
      expect(api.redirectUri, Uri.parse(redirectUri));
      expect(api.clientSecret, clientSecret);
    });

    test('Server with URI', () {
      const clientSecret = 'clientSecret';
      final redirectUri = Uri.parse('example.com');
      final api = GeniusApiAuth.server(
        clientSecret: clientSecret,
        redirectUri: redirectUri,
      );
      expect(api.clientId, null);
      expect(api.redirectUri, redirectUri);
      expect(api.clientSecret, clientSecret);
    });
  });
}
