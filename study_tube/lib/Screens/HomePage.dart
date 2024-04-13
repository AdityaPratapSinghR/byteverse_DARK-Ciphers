import 'package:app/Util/PlaylistInfo.dart';
import 'package:app/Util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../Database/PlaylisDB.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final playlistController = TextEditingController();
    String userID = "";
    userID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              TextField(
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 1, vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                  hintText: "Enter playlist link",
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => {
                  addPlaylistItem(userID,
                      getPlaylistIdFromLink(playlistController.value.text), 0),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Adding Playlist! Be Patient!"),
                    ),
                  ),
                },
              ),
              SizedBox(
                height: 10,
              ),
              new StreamBuilder(
                  stream: fetchUserPlaylistAndShow(userID),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot){
                    if (snapshot.hasData) {
                      print("My Title" + snapshot.data.toString());
                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: new ListView.builder(
                          itemCount: snapshot.data?.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String playlistID =
                                    snapshot.data![index].playlistID;
                                Navigator.of(context).pushNamed(
                                  MyRoutes.playlistPage,
                                  arguments: playlistID,
                                );
                              },
                              child: Card(
                                child: Row(
                                  children: [
                                    Image.network(
                                      snapshot.data![index].thumbUrl,
                                      width:
                                      MediaQuery.of(context).size.width / 3,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    new Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].title,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          snapshot.data![index].numOfVids
                                              .toString(),
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Divider()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return new Text("${snapshot.error}");
                    }
                    return new Align(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addPlaylistItem(
      String userId, String playlistId, int progress) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection(userId).doc("playlist");

    try {
      final newItem = {'playlistID': playlistId, 'progress': progress};

      await docRef.update({
        'playlists': FieldValue.arrayUnion([newItem]),
      });

      print('Playlist item added succesfully!!');
      setState(() {});
    } on FirebaseException catch (e) {
      print('Error adding playlist item: ${e.message}');
    }
  }
}

String getPlaylistIdFromLink(String link) {
  final RegExp playlistIdRegex = RegExp(r'list=PL([a-zA-Z0-9]+)');

  if (link.startsWith('https://youtube.com/playlist?') ||
      link.startsWith('https://www.youtube.com/playlist?')) {
    // final match = playlistIdRegex.firstMatch(link);
    final RegExp regex = RegExp(r'list=([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(link);
    if (match != null) {
      return match.group(1)!; // Extract the captured group (playlist ID)
    } else {
      throw FormatException('Invalid YouTube playlist URL');
    }
  } else {
    throw FormatException('Link must start with https://youtube.com/playlist?');
  }
}

Stream<List<PlaylistInfo>> fetchUserPlaylistAndShow(String userId) async*{
  CollectionReference userIdDb = FirebaseFirestore.instance.collection(userId);
  DocumentReference playlist = userIdDb.doc("playlist");
  List<PlaylistInfo> playListInfoList = [];
  String playlistIds ="";
  try{
    final value = await playlist.get();
    List<PlaylistDB> playlists = (value['playlist'] as List<dynamic>)
        .map((item)=>PlaylistDB(
      playlistId :item['playlistId'],
      progress: item['progress'],
    ))
        .toList();
    for(int i=0 ; i < playlists.length ;i++){
      String playlistId = playlists[i].playlistId;
      String key = "AIzaSyBURViMCgdBTr5FMB2yNOgNxv-4sM3V238";
      String playlistUrl = "https://youtube.googleapis.com/youtube/v3/playlists"
          "?part=contentDetails&part=snippet&id=$playlistId&key=$key";

      final response = await http.get(Uri.parse(playlistUrl));

      if (response.statusCode == 200){
        final data = json.decode(response.body) as Map<String, dynamic>;
        List items = data['items'];

        for (int j=0; j< items.length; j++){
          var snippet = items[j]['snippet'];
          final title = snippet['title'] as String;
          final channelName = snippet['channelTitle'] as String;
          var thumbnail = snippet['thumbnails']['maxres'];
          final thumbUrl = thumbnail['url'] as String;
          var contentDetails = items[j]['contentDetails'];
          final numOfVids = contentDetails['itemCount'] as int;

          PlaylistInfo playlistInfo = PlaylistInfo(
              thumbUrl: thumbUrl,
              title: title,
              channelName: channelName,
              numOfVideos: numOfVids,
              progress: playlists[i].progress,
              playlistId: playlistId
          );
          playListInfoList.add(playlistInfo);
        }
      }else {
        throw Exception('Failed to load playlist information!');
      }
    }
    yield playListInfoList;
  }catch(error){
    print("Failed to fetch data: $error");
    yield[];
  }
}


