import "package:flutter/material.dart";
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_manager/audio_manager.dart';

import './song_list.dart';

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark, primaryColor: Colors.blueGrey),
        home: Scaffold(
          appBar: drawMainAppBar(),
          body: FutureBuilder(
            future: FlutterAudioQuery()
                .getSongs(sortType: SongSortType.RECENT_YEAR),
            builder: (context, snapshot) {
              List<SongInfo> songInfo = snapshot.data;
              if (snapshot.hasData)
                return SongList(snapshot.data);
              else
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Loading....",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
            },
          ),
        ));
  }
}

Widget drawMainAppBar() {
  return AppBar(
    title: Text("Music Player"),
    leading: Icon(
      Icons.view_headline_rounded,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    ),
    actions: [Icon(Icons.volume_up_sharp)],
  );
}
