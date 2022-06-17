enum MediaCommandType implements Enum {
  LOAD,
  PAUSE,
  STOP,
  PLAY,

  VOLUME,
  GET_STATUS,
  SEEK,
  QUEUE_INSERT,
  QUEUE_GET_ITEM_IDS,
  QUEUE_GET_ITEMS,
  QUEUE_UPDATE,
  QUEUE_REMOVE,
  QUEUE_REORDER,
  QUEUE_LOAD,

  ///Go to the next item in queue
  QUEUE_NEXT,

  ///Go to the previous item in queue
  QUEUE_PREV,

  ///Seek 10 seconds forward
  SEEK_FORWARD_10,

  ///Seek 15 seconds forward

  SEEK_FORWARD_15,

  ///Seek 30 seconds forward

  SEEK_FORWARD_30,

  ///Seek 10 seconds backward
  SEEK_BACKWARD_10,

  ///Seek 15 seconds backward
  SEEK_BACKWARD_15,

  ///Seek 30 seconds backward
  SEEK_BACKWARD_30,

  ///Turn on/off closed captions
  CAPTIONS,

  ///Toggle repeat mode.
  REPEAT,

  ///Toggle shuffle mode.

  SHUFFLE,

  ///Like toggle button with a thumbs up icon style.

  LIKE,

  ///Like toggle button with a heart icon style.
  LIKE_HEART,

  ///Dislike toggle button with a thumbs down icon style.
  DISLIKE;

  final String? value;
  const MediaCommandType({this.value});

  @override
  String toString() => value ?? name;
}
