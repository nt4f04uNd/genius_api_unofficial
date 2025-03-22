import 'dart:convert';

class AuthRedirectData {
  final String? code;
  final String? accessToken;

  AuthRedirectData({required this.code, required this.accessToken});

  factory AuthRedirectData.fromJson(Map<String, dynamic> json) =>
      AuthRedirectData(
        code: json['code'] as String?,
        accessToken: json['access_token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'access_token': accessToken,
      };

  String toJsonString() => jsonEncode(toJson());

  static AuthRedirectData fromJsonString(String jsonString) =>
      AuthRedirectData.fromJson(jsonDecode(jsonString));

  static AuthRedirectData parseFromUri(Uri uri) {
    // Extract code from URI
    // https://www.google.com/?code=123
    final String? code = uri.queryParameters['code'];

    String? accessToken;
    // Extract access_token from URI
    // https://www.google.com/#access_token=1231&state=TEST_STATE&token_type=bearer
    if (uri.fragment.isNotEmpty) {
      final fragment = uri.fragment;

      // Check if the fragment contains the access_token and extract it
      final regex = RegExp(r'access_token=([^&]+)');
      final match = regex.firstMatch(fragment);

      if (match != null) {
        accessToken = match.group(1) ?? '';
      }
    }

    return AuthRedirectData(code: code, accessToken: accessToken);
  }
}
