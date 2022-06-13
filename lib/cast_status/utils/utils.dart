import 'package:cast/cast.dart';

CastMediaMetadata getCastMediaMetadata(Map<String, dynamic> json) {
  switch (json['metadataType'] as int) {
    case 0:
      return CastGenericMediaMetadata.fromMap(json);
    case 1:
      return CastMovieMediaMetadata.fromMap(json);
    case 2:
      return CastTvShowMediaMetadata.fromMap(json);
    default:
      throw Exception('Unknown metadataType');
  }
}
