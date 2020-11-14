import "package:flutter/material.dart";
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:audio_manager/audio_manager.dart';

import 'dart:io';
import 'main.dart';

class SongList extends StatelessWidget {
  final List<SongInfo> songList;
  var audioManagerInstance = AudioManager.instance;

  SongList(this.songList);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      new Expanded(
          child: ListView.builder(
              itemCount: songList.length,
              itemBuilder: (context, songIndex) {
                SongInfo song = songList[songIndex];
                //if(song.albumArtwork==null)
                //return Text("blabla");
                //if (song.displayName.contains(".mp3"))
                return Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        ClipRect(
                          child: Image(
                            height: 90,
                            width: 150,
                            fit: BoxFit.cover,
                            image: song.albumArtwork == null
                                ? FileImage(File(songList[0].albumArtwork))
                                : FileImage(File(song.albumArtwork)),
                          ),
                        ),
                        Container(
                          //width: MediaQuery.of(context).size.width * 0.5,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(song.title,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Text("Release Year: ${song.year}",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  Text("Artist: ${song.artist}",
                                      style: TextStyle(
                                          fontSize: 7,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  Text("Composer: ${song.composer}",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      "Duration: ${parseToMinutesSeconds(int.parse(song.duration))} min",
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  print("trying to play>>>>>>>>>>>>>>>>>>>>");
                                  if (audioManagerInstance != null) {
                                    if (audioManagerInstance.isPlaying) audioManagerInstance.stop();
                                    audioManagerInstance.release();
                                    //audioManagerInstance = null;
                                  }
                                  audioManagerInstance
                                      .start(
                                          "file://${song.filePath}", song.title,
                                          desc: song.displayName,
                                          auto: true,
                                          cover: song.albumArtwork)
                                      .then((err) {
                                    print(err);
                                  });
                                },
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
      Text(songList.length.toString() + " songs ")
    ]);
  }

  static String parseToMinutesSeconds(int ms) {
    String data;
    Duration duration = Duration(milliseconds: ms);

    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);

    data = minutes.toString() + ":";
    if (seconds <= 9) data += "0";

    data += seconds.toString();
    return data;
  }
}
