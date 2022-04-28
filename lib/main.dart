import 'package:flutter/material.dart';
import 'package:flutter_music_player/controllers/music_controller.dart';
import 'package:flutter_music_player/screens/music_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MusicController(),
        child: const MusicScreen(),
      ),
    );
  }
}