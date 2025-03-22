import 'tests.dart';

part 'secrets.g.dart';

/// Serializable test secrets to be used by tests.
class TestSecrets {
  TestSecrets({
    required this.email,
    required this.password,
    this.clientId,
    this.clientSecret,
    this.redirectUri,
  });

  /// User email to use in tests.
  final String email;

  /// User password to use in tests.
  final String password;

  /// [GeniusApiAuth.clientId].
  final String? clientId;

  /// [GeniusApiAuth.clientSecret].
  final String? clientSecret;

  /// [GeniusApiAuth.redirectUri].
  final String? redirectUri;

  /// Constructs object from JSON map.
  factory TestSecrets.fromJson(Map<String, dynamic> json) =>
      _$TestSecretsFromJson(json);

  /// Creates an object from the JSON file.
  factory TestSecrets.load() {
    final fileUri = Uri.file('test/.env/secrets.json');
    final file = File.fromUri(fileUri);
    if (file.existsSync()) {
      return TestSecrets.fromJson(
        jsonDecode(File.fromUri(fileUri).readAsStringSync()),
      );
    } else {
      throw Exception(
          "The `secrets.json` wasn't by path: ${fileUri.toFilePath()}. Have you created it?");
    }
  }
}
