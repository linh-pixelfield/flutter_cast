///optional If the playerState is IDLE and the reason it
///became IDLE is known, this property is provided. If the
/// player is IDLE because it just started, this property
/// will not be provided; if the player is in any other
/// state this property should not be provided.
///  The following values apply:

enum CastMediaIdleReason {
  /// A sender requested to stop playback using the STOP command
  cancelled('CANCELLED'),

  /// INTERRUPTED  A sender requested playing a different media using the LOAD command
  interrupted('INTERRUPTED'),

  /// The media playback completed
  finished('FINISHED'),

  ///ERROR  The media was interrupted due to an error; for example, if the player could not download the media due to network issues
  error('ERROR');

  final String value;
  const CastMediaIdleReason(this.value);
  factory CastMediaIdleReason.fromString(String value) =>
      CastMediaIdleReason.values.firstWhere(
        (element) => element.value == value,
        orElse: () => CastMediaIdleReason.error,
      );
}
