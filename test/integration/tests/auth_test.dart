import 'package:test/test.dart';

import '../../tests.dart';
import '../selenium.dart';

void main() {
  final secrets = TestSecrets.load();
  final auth = GeniusApiAuth(
    clientId: secrets.clientId,
    clientSecret: secrets.clientSecret,
    redirectUri: secrets.redirectUri,
  );

  const timeout = Timeout(Duration(minutes: 2));

  group(
    'Auth methods | ',
    () {
      test(
        'authorize + token exchange by code',
        () async {
          final authUri = auth.constructAuthorize(
            scope: GeniusApiAuthScope.values.toList(),
            responseType: GeniusApiAuthResponseType.code,
            state: 'TEST_STATE',
          );
          final authRedirectData = await authorizeWithSelenium(
            secrets.email,
            secrets.password,
            authUri,
          );

          expect(authRedirectData.accessToken, null);
          expect(authRedirectData.code, isA<String>());

          final accessToken = await auth.token(authRedirectData.code!);
          expect(accessToken, isA<String>());
        },
        timeout: timeout,
      );

      test(
        'authorize - direct token obtaining',
        () async {
          final authUri = auth.constructAuthorize(
            scope: GeniusApiAuthScope.values.toList(),
            responseType: GeniusApiAuthResponseType.token,
            state: 'TEST_STATE',
          );
          final authRedirectData = await authorizeWithSelenium(
            secrets.email,
            secrets.password,
            authUri,
          );

          expect(authRedirectData.accessToken, isA<String>());
          expect(authRedirectData.code, null);
        },
        timeout: timeout,
      );
    },
  );
}
