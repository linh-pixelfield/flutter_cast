class CastMediaMetadata {
  final MediaMetadataType metadataType;
  CastMediaMetadata({
    required this.metadataType,
  });

  Map<String, dynamic> toMap() {
    return {
      'metadataType': metadataType,
    };
  }
}

enum MediaMetadataType {
  genericMediaMetadata(0),
  movieMediaMetadata(1),
  tvShowMediaMetadata(2),
  musicTrackMediaMetadata(3),
  photoMediaMetadata(4);

  final int value;
  const MediaMetadataType(this.value);

  factory MediaMetadataType.fromInt(int value) {
    return values.firstWhere(
      (element) => element.value == value,
      orElse: () => genericMediaMetadata,
    );
  }
}
