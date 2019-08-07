import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'notificare_inbox_item.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

class NotificareInboxItem {
  NotificareInboxItem(this.inboxId);

  String inboxId;
  String notification;
  String message;
  String time;
  bool opened;

  factory NotificareInboxItem.fromJson(dynamic json) => _$NotificareInboxItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareInboxItemToJson(this);
}