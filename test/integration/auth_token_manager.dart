import 'dart:io';

import 'auth_redirect_data.dart';

class AuthRedirectDataManager {
  static const String _storePath = 'test/.env/auth_redirect_data_store.json';

  Future<void> save(AuthRedirectData authRedirectData) async {
    try {
      await File(_storePath).writeAsString(authRedirectData.toJsonString());
      print("Auth data saved to $_storePath");
    } catch (e) {
      print("Error saving auth data to file: $e");
    }
  }

  Future<AuthRedirectData?> load() async {
    try {
      final jsonData = await File(_storePath).readAsString();
      return AuthRedirectData.fromJsonString(jsonData);
    } catch (e) {
      print("Error loading auth data from file: $e");
      return null;
    }
  }
}
