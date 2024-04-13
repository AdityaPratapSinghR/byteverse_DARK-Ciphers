import 'package:flutter/material.dart';
class PlaylistInfo{
  String playlistId;
  String thumbUrl;
  String title;
  String channelName;
  int numOfVids;
  int progress;
  PlaylistInfo({required this.thumbUrl, required this.title, required this.channelName, required this.numOfVids, required this.progress,required this.playlistId});
}