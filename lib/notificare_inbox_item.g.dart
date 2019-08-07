// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_inbox_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareInboxItem _$NotificareInboxItemFromJson(Map<String, dynamic> json) {
  return NotificareInboxItem(json['inboxId'] as String)
    ..notification = json['notification'] as String
    ..message = json['message'] as String
    ..time = json['time'] as String
    ..opened = json['opened'] as bool;
}

Map<String, dynamic> _$NotificareInboxItemToJson(
        NotificareInboxItem instance) =>
    <String, dynamic>{
      'inboxId': instance.inboxId,
      'notification': instance.notification,
      'message': instance.message,
      'time': instance.time,
      'opened': instance.opened
    };
