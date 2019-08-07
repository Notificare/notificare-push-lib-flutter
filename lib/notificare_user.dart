import 'package:json_annotation/json_annotation.dart';
import 'package:notificare_push_lib/notificare_user_segment.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'notificare_user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

class NotificareUser {
  NotificareUser();

  String userID;
  String userName;
  List<NotificareUserSegment> segments;

  factory NotificareUser.fromJson(Map<String, dynamic> json) => _$NotificareUserFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserToJson(this);
}