import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/model/song.dart';

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Song> playList = [
    Song(
      songName: "Sample 1",
      artistName: "N/A",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-3s.mp3",
      totalDuration: 3,
    ),
    Song(
      songName: "Sample 2",
      artistName: "N/A",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-6s.mp3",
      totalDuration: 6,
    ),
    Song(
      songName: "Sample 3",
      artistName: "N/A",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-9s.mp3",
      totalDuration: 9,
    ),
    Song(
      songName: "Sample 4",
      artistName: "N/A",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-12s.mp3",
      totalDuration: 12,
    ),
    Song(
      songName: "Sample 5",
      artistName: "N/A",
      songUrl: "https://samplelib.com/lib/preview/mp3/sample-15s.mp3",
      totalDuration: 15,
    ),
  ];

  int currentIndex = 0;
  bool isPlay = false;

  Duration songDuration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    eventListener();
    _playSong(currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Song song = playList[currentIndex];
    final double totalDuration = max(songDuration.inSeconds.toDouble(), 1);
    final double currentPosition = position.inSeconds.toDouble().clamp(
      0,
      totalDuration,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Music App",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow.shade300,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Card(
            color: Colors.grey[50],
            child: Column(
              children: [
                Text(song.songName),
                Text(song.artistName),
                Slider(value: 0, onChanged: (value) {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(timeFormat(position)),
                    Text(timeFormat(songDuration)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: previousSong,
                      icon: Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      onPressed: toggleButton,
                      icon: Icon(isPlay ? Icons.pause : Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: nextSong,
                      icon: Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: playList.length,
              itemBuilder: (context, index) {
                final bool isPlayNow = index == currentIndex;
                return ListTile(
                  title: Text(playList[index].songName),
                  subtitle: Text(playList[index].artistName),
                  trailing: Icon(isPlayNow ? Icons.pause : Icons.play_arrow),
                  leading: Text("${index + 1}"),
                  onTap: () => _playSong(index),
                  selected: isPlayNow,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void eventListener() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        songDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlay = state == PlayerState.playing;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      nextSong();
    });
  }

  Future<void> _playSong(int index) async {
    currentIndex = index;
    final song = playList[index];
    setState(() {
      songDuration = Duration(seconds: song.totalDuration);
      position = Duration.zero;
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(song.songUrl));
  }

  Future<void> nextSong() async {
    final next = (currentIndex + 1) % playList.length;
    await _playSong(next);
  }

  Future<void> previousSong() async {
    final previous = (currentIndex - 1 + playList.length) % playList.length;
    await _playSong(previous);
  }

  Future<void> toggleButton() async {
    if (isPlay) {
      await _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
  }

  String timeFormat(Duration duration) {
    final minute = duration.inMinutes;
    final second = duration.inSeconds.remainder(60);

    return "$minute ${second.toString().padLeft(2, "0")}";
  }
}
