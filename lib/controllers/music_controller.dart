import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/constants/state.dart';
import 'package:flutter_music_player/models/music.dart';
import 'package:flutter_music_player/repositories/music_repository.dart';

class MusicController extends ChangeNotifier {
  final MusicRepository _musicRepository = MusicRepository();
  final AudioPlayer audioPlayer = AudioPlayer();

  DataState dataState = DataState.loading;
  List<Music> musicList = [];

  bool playMusic = false;
  bool pauseMusic = true;

  int indexMusic = -1;
  String searchTerm = 'Jack';

  void changeState(DataState state) {
    dataState = state;
    notifyListeners();
  }

  void updateMusicPlayAndIndex(int index, bool play) {
    indexMusic = index;
    playMusic = play;
    notifyListeners();
  }

  void updateMusicPause(bool value) {
    pauseMusic = value;
    notifyListeners();
  }

  void updateSearchTerm(String value) {
    searchTerm = value;
    notifyListeners();
  }

  void getMusicList() async {
    changeState(DataState.loading);

    try {
      musicList = await _musicRepository.getMusicList(searchTerm);
      changeState(DataState.filled);
    } catch(e) {
      changeState(DataState.error);
    }
  }
}