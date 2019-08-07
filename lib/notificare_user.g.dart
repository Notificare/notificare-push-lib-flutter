// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareUser _$NotificareUserFromJson(Map<String, dynamic> json) {
  return NotificareUser()
    ..userID = json['userID'] as String
    ..userName = json['userName'] as String
    ..segments = (json['segments'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareUserSegment.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NotificareUserToJson(NotificareUser instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'segments': instance.segments
    };
