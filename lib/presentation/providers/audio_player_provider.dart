import 'package:flutter/material.dart';

class AudioPlayerProvider extends ChangeNotifier {
  late AnimationController _playerController;
  bool _isPlaying = false;
  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _current = const Duration(milliseconds: 0);

  AnimationController get getPlayerController => _playerController;
  bool get getIsPlaying => _isPlaying;
  Duration get getSongDuration => _songDuration;
  Duration get getCurrent => _current;

  String get songTotalDuration => printDuration(_songDuration);
  String get currentSecond => printDuration(_current);

  double get songPercentage => (_songDuration.inSeconds > 0)
      ? (_current.inSeconds / _songDuration.inSeconds)
      : 0.0;

  void setPlayerController(AnimationController controller) {
    _playerController = controller;
  }

  void setIsPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  void setSongDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  void setCurrent(Duration value) {
    _current = value;
    notifyListeners();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";

      return "0$n";
    }

    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitsMinutes:$twoDigitsSeconds";
  }

 

}
