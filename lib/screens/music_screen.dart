import 'package:flutter/material.dart';
import 'package:flutter_music_player/constants/state.dart';
import 'package:flutter_music_player/controllers/music_controller.dart';
import 'package:flutter_music_player/widgets/music_card.dart';
import 'package:provider/provider.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  void initState() {
    super.initState();

    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Provider.of<MusicController>(context, listen: false).getMusicList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<MusicController>(context, listen: false).getMusicList();
        },
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Search Music',
                                contentPadding: EdgeInsets.only(
                                  left: 8.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? value) {
                                if (value != null && value.isNotEmpty) {
                                  Provider.of<MusicController>(context, listen: false).updateSearchTerm(value);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Consumer<MusicController>(
                          builder: (BuildContext context, MusicController controller, Widget? child) {
                            return ElevatedButton(
                              onPressed: () async {
                                controller.getMusicList();

                                if (controller.playMusic) {
                                  controller.updateMusicPlayAndIndex(-1, false);
                                  await controller.audioPlayer.stop();
                                }
                              },
                              child: const Text('Search'),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<MusicController>(
                      builder: (BuildContext context, MusicController controller, Widget? child) {
                        if (controller.dataState == DataState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.dataState == DataState.error) {
                          return const Center(
                            child: Text(
                              'Something went wrong!',
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: controller.musicList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MusicCard(
                              trackName: controller.musicList[index].trackName ?? 'No track name',
                              imageUrl: controller.musicList[index].artworkUrl30 ?? '',
                              artistName: controller.musicList[index].artistName ?? '',
                              releaseDate: controller.musicList[index].releaseDate ?? '',
                              trackPrice: controller.musicList[index].trackPrice ?? 0.0,
                              icon: controller.indexMusic == index ? Icons.pause : Icons.play_circle_outline,
                              onTap: () async {
                                if (!controller.playMusic || controller.indexMusic != index) {
                                  controller.updateMusicPlayAndIndex(index, true);
                                  controller.updateMusicPause(false);
                                  await controller.audioPlayer.play(controller.musicList[index].previewUrl ?? '');
                                } else {
                                  controller.updateMusicPlayAndIndex(-1, false);
                                  controller.updateMusicPause(true);
                                  await controller.audioPlayer.stop();
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                Consumer<MusicController>(
                  builder: (BuildContext context, MusicController controller, Widget? child) {
                    String trackName = 'No music playing right now';

                    if (controller.indexMusic > 0) {
                      trackName = controller.musicList[controller.indexMusic].trackName ?? '';
                    }

                    return Text(
                      trackName,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        child: Center(
                          child: Consumer<MusicController>(
                            builder: (BuildContext context, MusicController controller, Widget? child) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.fast_rewind_sharp,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  int position = await controller.audioPlayer.getCurrentPosition();
                                  await controller.audioPlayer.seek(
                                    Duration(
                                      milliseconds: position - 2000,
                                    ),
                                  );
                                },
                              );
                            }
                          ),
                        ),
                        backgroundColor: Colors.cyan,
                      ),
                      CircleAvatar(
                        radius: 30,
                        child: Center(
                          child: Consumer<MusicController>(
                            builder: (BuildContext context, MusicController controller, Widget? child) {
                              return IconButton(
                                onPressed: () {
                                  if (controller.pauseMusic) {
                                    controller.audioPlayer.resume();
                                    controller.updateMusicPause(false);
                                  } else {
                                    controller.audioPlayer.pause();
                                    controller.updateMusicPause(true);
                                  }
                                },
                                padding: const EdgeInsets.all(0.0),
                                icon: Icon(
                                  controller.pauseMusic ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                      CircleAvatar(
                        child: Center(
                          child: Consumer<MusicController>(
                            builder: (BuildContext context, MusicController controller, Widget? child) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.fast_forward_sharp,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  int position = await controller.audioPlayer.getCurrentPosition();
                                  await controller.audioPlayer.seek(
                                    Duration(
                                      milliseconds: position + 2000,
                                    ),
                                  );
                                },
                              );
                            }
                          ),
                        ),
                        backgroundColor: Colors.cyan,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
