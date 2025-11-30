import 'package:flutter/material.dart';

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
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
                  trailing: Icon(Icons.skip_next),
                  leading: Text("${index + 1}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
