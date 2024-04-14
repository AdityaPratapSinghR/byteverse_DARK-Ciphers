import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VideoPageWeb extends StatelessWidget {
  final String videoId;
  final double playback;
  final String title;

  const VideoPageWeb({Key? key, required this.videoId,required this.title, this.playback = 1.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String html = "<!DOCTYPE html>\n" +
        "<html>\n" +
        "<head>\n" +
        "    <meta http-equiv=\"content-type\" content=\"text/html; charset=UTF-8\">\n" +
        "    <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js\"></script>\n" +
        "    <title></title>\n" +
        "\n" +
        "    <style type=\"text/css\">\n" +
        "\n" +
        "    iframe {\n" +
        "      position: absolute;\n" +
        "      border: none;\n" +
        "      box-sizing: border-box;\n" +
        "      width: 100%;\n" +
        "      height: 100%;\n" +
        "       margin: 0;\n" +
        "       padding: 0;\n" +
        "    }\n" +
        "  </style>\n" +
        "\n" +
        "    <script>\n" +
        "\n" +
        "    var player;\n" +
        "\n" +
        "    // init player\n" +
        "    function onYouTubeIframeAPIReady() {\n" +
        "      player = new YT.Player('player', {\n" +
        "        height: '0',\n" +
        "        width: '0',\n" +
        "         margin: '0',\n" +
        "         padding: '0',\n" +
        "        suggestedQuality: 'hd720',\n" +
        "        playerVars: {rel: 1, showinfo: 1},\n" +
        "        events: {\n" +
        "          'onReady': onPlayerReady,\n" +
        "          'onStateChange': onPlayerStateChange\n" +
        "        }\n" +
        "      });\n" +
        "    }\n" +
        "\n" +
        "    function loadVideo(target){\n" +
        "      target.loadVideoById('"+videoId+"', 0, 'hd720');\n" +
        "    }\n" +
        "\n" +
        "    function onPlayerStateChange(event) {\n" +
        "        var playbackQuality = event.target.getPlaybackQuality();\n" +
        "        var suggestedQuality = 'hd720';\n" +
        "        if( playbackQuality !== 'hd720') {\n" +
        "            event.target.setPlaybackQuality( suggestedQuality );\n" +
        "        }\n" +
        "    }\n" +
        "\n" +
        "    // when ready, wait for clicks\n" +
        "    function onPlayerReady(event) {\n" +
        "      event.target.setPlaybackQuality('hd720');\n" +
        "      var player = event.target;\n" +
        "      player.setPlaybackRate("+playback.toString()+");\n" +
        "      loadVideo(player);\n" +
        "    }\n" +
        "  </script>\n" +
        "</head>\n" +
        "\n" +
        "<body id=\"body\"style=\"margin: 0; padding: 0\">\n" +
        "<div id=\"video_div\">\n" +
        "    <script src=\"https://www.youtube.com/iframe_api\"></script>\n" +
        "    <div id=\"bottom\">\n" +
        "        <div id=\"player\"></div>\n" +
        "    </div>\n" +
        "</div>\n" +
        "</body>\n" +
        "</html>";

    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube Video Player'),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: MediaQuery.of(context).size.width,
              child: InAppWebView(
                initialData: InAppWebViewInitialData(data: html),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  // Here you can execute JavaScript code or handle WebView events
                },
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
