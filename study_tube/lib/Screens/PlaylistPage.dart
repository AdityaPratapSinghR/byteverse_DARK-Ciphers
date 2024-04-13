import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Util/VideoInfo.dart';
import '../Util/routes.dart';

Future<List<PlaylistInfo>> fetchVideos(String playlistId) async {
  String key = "AIzaSyBURViMCgdBTr5FMB2yNOgNxv-4sM3V238";
  String url =
      "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&playlistId=" +
          playlistId +
          "&key=" +
          key +
          "&maxResults=10";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<PlaylistInfo> videoInfoList = [];
    //If the server did return a 200 0K response,
    // then parse the JSON.
  final data = json.decode(response.body.toString()) as Map<String, dynamic>;
  List items = data['items'] as List<dynamic>;
  if (items.isNotEmpty) {
    print(items.length);
    for (int i = 0; i < items.length; i++) {
      print(i);
      var snippet = items[i]['snippet'] as Map<String, dynamic>;
      final title = snippet['title'] as String;
      final channelName = snippet['channelTitle'] as String;
      final videoId = snippet['resourceId']['videoId'] as String;
      var thumbnail = snippet['thumbnails'] as Map<String, dynamic>;
      var maxRes = thumbnail['maxres'] as Map<String, dynamic>;
      final thumbUrl = maxRes['url'] as String;


      final duration = await getVideoDuration(videoId);

      PlaylistInfo videoInfo = PlaylistInfo(
          thumbnail: thumbUrl,
          title: title,
          duration: duration,
          channelName: channelName,
          videoId: videoId);
      videoInfoList.add(videoInfo);
    }
  }
  return videoInfoList;
  } else {
    //If the server did not return a 200 OK response,
    //then throw an exception.
    throw Exception('Failed to load album');
  }
}

  Future<String> getVideoDuration(String videoId) async {
  String key = "AIzaSyBURViMCgdBTr5FMB2yNOgNxv-4sM3V238";
  final String url =
      'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=$videoId&key=$key';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    if (items.isNotEmpty) {
      final contentDetails = items[0]['contentDetails'] as Map<String, dynamic>;
      final duration = contentDetails['duration'] as String;
      return duration;
    }  else {
      return 'Duration not found'; //Handle case where video details not found
    }
  } else {
    // Handle API request error
    print('Error fetching video details: ${response.statusCode}');
    return 'Error';
  }
}
class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    //Retrieve the playlist ID from the arguments
    final String playlistId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text("Videos"),elevation: 0,),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: new FutureBuilder<List<PlaylistInfo>>(
            future: fetchVideos(playlistId),
            builder: (BuildContext context,
                AsyncSnapshot<List<PlaylistInfo>> snapshot ) {
              if (snapshot.hasData) {
                return new ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {

                      return GestureDetector(
                        onTap: (){
                          String videoId = snapshot.data![index].videoId;
                          Navigator.of(context).pushNamed(
                            MyRoutes.videoPage,
                            arguments: videoId,
                          );
                        },
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(snapshot.data![index].thumbnail,),
                            Text(snapshot.data![index].title,
                            style: new TextStyle(fontWeight: FontWeight.bold)),

                            Text(getTime(convertTime(snapshot.data![index].duration))),
                            Divider()
                          ]),
                        );
                    });
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }
              //By default, show a loading spinner
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

int convertTime(String duration) {

  RegExp regex = new RegExp(r'(\d+)');
  List<String> a = regex.allMatches(duration).map((e) => e.group(0)!).toList();

  if (duration.indexOf('M') >= 0 &&
      duration.indexOf('H') == -1 &&
      duration.indexOf('S') == -1) {
    a = ["0", a[0], "0"];
  }

  if (duration.indexOf('H') >= 0 && duration.indexOf('M') == -1) {
    a = [a[0], "0", a[1]];
  }
  if (duration.indexOf('H') >= 0 &&
      duration.indexOf('M') == -1 &&
      duration.indexOf('S') == -1) {
    a = [a[0], "0", "0"];
  }

  int seconds = 0;

  if (a.length == 3) {
    seconds = seconds + int.parse(a[0]) * 3600;
    seconds = seconds + int.parse(a[1]) * 60;
    seconds = seconds + int.parse(a[2]);
  }

  if (a.length == 2) {
    seconds = seconds + int.parse(a[0]) * 60;
    seconds = seconds + int.parse(a[1]);
  }

  if (a.length == 1) {
    seconds = seconds + int.parse(a[0]);
  }
  return seconds;
}
String getTime(int second){
  String time;
  int minutes = second~/60;
  int hour = minutes~/60;
  if(hour>=1){
    int remainingMin = minutes - hour*60;
    int remainingSecs = second - remainingMin*60 - hour*3600;
    time = "$hour:$remainingMin:$remainingSecs";
  }else if(minutes>=1){
    int remainingSeconds = second - minutes*60;
    time = "$minutes:$remainingSeconds";
  }else{
    time = "$second";
  }


  return time;
}
