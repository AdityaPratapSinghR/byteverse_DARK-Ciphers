class PlaylistInfo {
  String playlistId;
  String thumbUrl;
  String title;
  String channelName;
  int numOfVideos;
  int progress;

  PlaylistInfo({
    required this.thumbUrl, required this.title,required this.channelName,
    required this.numOfVideos,required this.progress,required this.playlistId
  });
}