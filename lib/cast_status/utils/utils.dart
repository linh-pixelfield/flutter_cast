import 'package:cast/common/media_metadata/cast_media_metadata.dart';
import 'package:cast/common/media_metadata/generic_media_metadata.dart';
import 'package:cast/common/media_metadata/movie_media_metadata.dart';
import 'package:cast/common/media_metadata/tv_show_media_metadata.dart';

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
