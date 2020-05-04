// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestConfig _$TestConfigFromJson(Map<String, dynamic> json) {
  return TestConfig(
    accessTokenClient: json['accessTokenClient'] as String,
    accessTokenUser: json['accessTokenUser'] as String,
    accessTokenUserMe: json['accessTokenUserMe'] as String,
    accessTokenUserCreateAnnotation:
        json['accessTokenUserCreateAnnotation'] as String,
    accessTokenUserManageAnnotation:
        json['accessTokenUserManageAnnotation'] as String,
    accessTokenUserVote: json['accessTokenUserVote'] as String,
    accessTokenUserAll: json['accessTokenUserAll'] as String,
    clientId: json['clientId'] as String,
    clientSecret: json['clientSecret'] as String,
    redirectUri: json['redirectUri'] as String,
    exchangeCode: json['exchangeCode'] as String,
    skipGroup: json['skipGroup'] as bool,
    skipTest: json['skipTest'] as bool,
    skipExpect: json['skipExpect'] as bool,
  );
}

Map<String, dynamic> _$TestConfigToJson(TestConfig instance) =>
    <String, dynamic>{
      'accessTokenClient': instance.accessTokenClient,
      'accessTokenUser': instance.accessTokenUser,
      'accessTokenUserMe': instance.accessTokenUserMe,
      'accessTokenUserCreateAnnotation':
          instance.accessTokenUserCreateAnnotation,
      'accessTokenUserManageAnnotation':
          instance.accessTokenUserManageAnnotation,
      'accessTokenUserVote': instance.accessTokenUserVote,
      'accessTokenUserAll': instance.accessTokenUserAll,
      'clientId': instance.clientId,
      'clientSecret': instance.clientSecret,
      'redirectUri': instance.redirectUri,
      'exchangeCode': instance.exchangeCode,
      'skipGroup': instance.skipGroup,
      'skipTest': instance.skipTest,
      'skipExpect': instance.skipExpect,
    };
