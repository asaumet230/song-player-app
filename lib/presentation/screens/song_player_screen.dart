import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../config/config.dart';
import '../../helpers/helpers.dart';
import '../providers/providers.dart';

class SongPlayerScreen extends StatelessWidget {
  const SongPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppTheme.backgroundColor,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [
                Color(0xff33333E),
                Color(0xff201E18),
              ],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.angleLeft),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.message),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.headphones),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.upRightFromSquare),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _BackgroundPlayer(),
          _SongView(),
        ],
      ),
    );
  }
}

class _BackgroundPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.65,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: <Color>[
            Color(0xff33333E),
            Color(0xff201E18),
          ],
        ),
      ),
    );
  }
}

class _SongView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 70, 25, 0),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _SongImage(),
              const SizedBox(width: 40),
              _ProgressBar(),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 40),
          _SongInfo(),
          const SizedBox(height: 50),
          Expanded(child: _SongLirycs()),
        ],
      ),
    );
  }
}

class _SongLirycs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lirycs = getLyrics();

    return ListWheelScrollView(
      physics: const BouncingScrollPhysics(),
      itemExtent: 42,
      diameterRatio: 1.5,
      children: lirycs
          .map(
            (line) => Text(
              line,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SongInfo extends StatefulWidget {
  @override
  State<_SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<_SongInfo>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool isFirstTime = true;
  late AnimationController playController;

  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();

    playController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    playController.dispose();
    super.dispose();
  }

  void open() async {
    final audioPlayerProvider = context.read<AudioPlayerProvider>();

    await assetAudioPlayer.open(
      Audio('assets/Breaking-Benjamin-Far-Away.mp3'),
      autoStart: true,
      showNotification: true,
    );

    //* Establecemos en donde va la canción:
    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerProvider.setCurrent(duration);
    });

    //* Establecemos la Duración de la canción:
    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerProvider.setSongDuration(
        playingAudio?.audio.duration ?? const Duration(seconds: 0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = context.watch<AudioPlayerProvider>();

    return Row(
      children: [
        const Column(
          children: [
            Text(
              'Far Away',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                height: 0,
              ),
            ),
            Text(
              '-Breaking Benjamin-',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const Spacer(),
        FloatingActionButton(
          highlightElevation: 0, // Para evitar que se mueva el boton
          elevation: 0, // Para evitar que se mueva el boton
          onPressed: () {
            if (isPlaying) {
              playController.reverse();
              isPlaying = false;
              audioPlayerProvider.getPlayerController.stop();
            } else {
              playController.forward();
              isPlaying = true;
              audioPlayerProvider.getPlayerController.repeat();
            }

            if (isFirstTime) {
              open();
              isFirstTime = false;
            } else {
              assetAudioPlayer.playOrPause();
            }
          },
          backgroundColor: const Color(0XffF8CB51),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: AnimatedIcon(
            color: AppTheme.backgroundColor,
            icon: AnimatedIcons.play_pause,
            progress: playController,
          ),
        )
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = context.watch<AudioPlayerProvider>();

    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            audioPlayerProvider.songTotalDuration,
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          ),
          const SizedBox(height: 5),
          Stack(
            children: [
              Container(
                width: 3,
                height: 250,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 6,
                  height: audioPlayerProvider.songPercentage * 230,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            audioPlayerProvider.currentSecond,
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}

class _SongImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = context.watch<AudioPlayerProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      height: 250,
      width: 250,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration(seconds: 10),
              infinite: true,
              manualTrigger: true,
              controller: (controller) =>
                  audioPlayerProvider.setPlayerController(controller),
              child: Image.asset('assets/aurora.jpg'),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: const BoxDecoration(
                color: Color(0xff1C1C25),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
