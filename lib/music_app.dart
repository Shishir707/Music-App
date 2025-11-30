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
  final List<Song> playList = [];

  int currentIndex = 0;
  bool isPlay = false;

  Duration songDuration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Music App",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade200,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Card(
            color: Colors.grey[50],
            child: Column(
              children: [
                Text("Song name"),
                Text('Artist name'),
                Slider(value: 0, onChanged: (value) {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Current Time'), Text("Total Duration")],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.skip_previous),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.pause)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.skip_next)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Song name'),
                  subtitle: Text('Artist name'),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.skip_next),
                  ),
                  leading: Text("${index + 1}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _playSong(int index) async {
    currentIndex = index;
    final song = playList[index];
    setState(() {
      songDuration = Duration(seconds: song.totalDuration);
      position = Duration.zero;
    });
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(playList[index].songUrl));
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
}
