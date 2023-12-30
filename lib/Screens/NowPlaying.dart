import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key, required this.songModel, required this.audioPlayer});
  final SongModel songModel;
  final AudioPlayer audioPlayer;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {

  Duration _duration=new Duration();
  Duration _position=new Duration();

  bool _NowPlaying=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }
  void playSong(){
    try{
      widget.audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(widget.songModel.uri!))
      );
      widget.audioPlayer.play();
      bool _NowPlaying=true;
    }on Exception{
      log("Cannot parse song");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration-d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position=p!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios)),
              const SizedBox(
                height: 50.0,
              ),
              const Center(child: Column(
                children: [
                  CircleAvatar(
                    radius: 100.0,
                      child: Icon(Icons.music_note,size: 80.0,),
                  )
                ],
              ),),
              const SizedBox(
                height: 35.0,
              ),
              Text(widget.songModel.displayNameWOExt,overflow: TextOverflow.fade,maxLines: 1,style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Text(_position.toString().split(".")[0]),
                  Expanded(child: Slider(
                      min: Duration(microseconds: 0).inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      max: _duration.inSeconds.toDouble(),
                      onChanged: (value){
                    setState(() {
                      changetoSeconds(value.toInt());
                      value=value;
                    });
                  })),
                  Text(_duration.toString().split(".")[0]),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.skip_previous,size: 40,)),
                  Expanded(
                    child: IconButton(onPressed: (){
                      setState(() {
                        if(_NowPlaying){
                          widget.audioPlayer.pause();
                        }
                        else{
                          widget.audioPlayer.play();
                        }
                        _NowPlaying=!_NowPlaying;
                      });
                    }, icon: Icon(_NowPlaying? Icons.pause: Icons.play_arrow)),
                  ),
                  IconButton(onPressed: (){}, icon: Icon(Icons.skip_next,size: 40,)),
                ],
              ),

            ],
          ),
        ),

      ),
    );
  }
  void changetoSeconds(int Seconds){
    Duration duration=Duration(seconds: Seconds);
    widget.audioPlayer.seek(duration);
  }
}
