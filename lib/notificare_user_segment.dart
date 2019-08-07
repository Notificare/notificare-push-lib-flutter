import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'notificare_user_segment.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()

class NotificareUserSegment {
  NotificareUserSegment();

  String segmentId;
  String segmentLabel;

  factory NotificareUserSegment.fromJson(Map<String, dynamic> json) => _$NotificareUserSegmentFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserSegmentToJson(this);
}