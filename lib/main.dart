

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Screens/NowPlaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AllSongs(),
    );
  }
}
class AllSongs extends StatefulWidget {
  const AllSongs({super.key});

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }
  void requestPermission() {
    Permission.storage.request();
  }
  final AudioPlayer _audioPlayer=AudioPlayer();
  final _audioquery=new OnAudioQuery();
  playSong(String? uri){
    try{
      _audioPlayer.setAudioSource(
          AudioSource.uri(
          Uri.parse(uri!)
      )
      );
      _audioPlayer.play();
    }
    on Exception{
      log("Error playing song");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player 2023'),
        actions: [
          IconButton(onPressed: () {  },
          icon: const Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioquery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType:  UriType.EXTERNAL,
          ignoreCase: true
        ),

        builder: (context,item){
          if(item.data==null){
            return const Center(child: CircularProgressIndicator());
          }
          if(item.data!.isEmpty){
            return const Center(child: Text('No Songs Found'),);
          }
          return ListView.builder(itemBuilder: (context,index)=>ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(item.data![index].displayNameWOExt),
            trailing: const Icon(Icons.more_horiz),
            subtitle: Text('${item.data![index].artist}'),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NowPlaying(
                songModel: item.data![index],audioPlayer: _audioPlayer,
              )));
            },
          ),itemCount: item.data!.length,);
        }


      ),
    );
  }


}


