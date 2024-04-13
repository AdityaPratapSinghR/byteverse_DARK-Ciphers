import 'package:app/Util/PlaylistInfo.dart';
import 'package:app/Util/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../Database/PlaylisDB.dart';
import '../Util/Colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$playlist_id&key=${browserKey}&maxResults=50&pageToken=$nextPageToken;
  @override
  Widget build(BuildContext context) {
    final playlistController = TextEditingController();
    String userID = "";
    userID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        elevation: 1,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 1, horizontal: 13),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.black26,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.black26,
                          )),
                      hintText: "Enter playlist link",
                      hintStyle: TextStyle(fontSize: 13, color: Colors.black26)),
                  controller: playlistController,
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () => {
                    // print(getPlaylistIdFromLink(playlistController.value.text)),
                    addPlaylistItem(userID,
                        getPlaylistIdFromLink(playlistController.value.text), 0),
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Adding Playlist! Please Wait!"),
                    )),
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      alignment: Alignment.center,
                      height: 42,
                      width: double.infinity,
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        color: primaryColorLight,
                      ),
                      child: const Text(
                        "Get Playlist",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your Playlists",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                new StreamBuilder(
                  stream: fetchUserPlaylistAndShow(userID),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      print("My Title" + snapshot.data.toString());
                      return Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: new ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String playlistId = snapshot.data![index].playlistId;
                                Navigator.of(context).pushNamed(
                                  MyRoutes.playlistPage,
                                  arguments: playlistId,
                                );
                              },
                              child: Card(
                                child: Row(
                                  children: [
                                    Image.network(
                                      snapshot.data![index].thumbUrl,
                                      width: MediaQuery.of(context).size.width / 3,
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
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            snapshot.data![index].numOfVids
                                                .toString(),
                                            softWrap: false,
                                            overflow: TextOverflow.clip,
                                          ),
                                          Divider()
                                        ]),
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
                  },
                ),
              ],
            ),
          )),
    );
  }

  Future<void> addPlaylistItem(
      String userId, String playlistId, int progress) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection(userId).doc("playlist");

    try {
      // Create a new map for the playlist item
      final newItem = {'playlistId': playlistId, 'progress': progress};

      // Use FieldValue.arrayUnion for efficient addition to the array
      await docRef.update({
        'playlists': FieldValue.arrayUnion([newItem]),
      });

      print('Playlist item added successfully!');
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


Stream<List<PlaylistInfo>> fetchUserPlaylistAndShow(String userId) async* {
  CollectionReference userIdDb = FirebaseFirestore.instance.collection(userId);
  DocumentReference playlist = userIdDb.doc("playlist");
  List<PlaylistInfo> playListInfoList = [];
  String playlistIds = "";
  try {
    final value = await playlist.get();
    List<PlaylistDB> playlists = (value['playlists'] as List<dynamic>)
        .map((item) => PlaylistDB(
      playlistId: item['playlistId'],
      progress: item['progress'],
    ))
        .toList();

    for (int i = 0; i < playlists.length; i++) {
      String playlistId = playlists[i].playlistId;
      String key = "AIzaSyBURViMCgdBTr5FMB2yNOgNxv-4sM3V238";
      String playlistUrl = "https://youtube.googleapis.com/youtube/v3/playlists"
          "?part=contentDetails&part=snippet&id=$playlistId&key=$key";

      final response = await http.get(Uri.parse(playlistUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        List items = data['items'];

        for (int j = 0; j < items.length; j++) {
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
            numOfVids: numOfVids,
            progress: playlists[i].progress,
            playlistId: playlistId,
          );
          playListInfoList.add(playlistInfo);
        }
      } else {
        throw Exception('Failed to load playlist information');
      }
    }
    yield playListInfoList;
  } catch (error) {
    print("Failed to fetch data: $error");
    yield []; // Yield an empty list in case of an error
  }
}
