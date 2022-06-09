import 'package:cpa_demo_app/audio_file.dart';

class AudioFileCollection {
  final List<AudioFile> _audioFiles = [];

  AudioFileCollection.generate() {
    for (int i = 0; i < 5; i++) {
      _audioFiles.add(AudioFile());
    }
  }

  List<String> getFileNames() {
    return _audioFiles.map((audioFile) => audioFile.fileName).toList();
  }

  List<int> getLoadTimes() {
    return _audioFiles.map((audioFile) => audioFile.loadTime).toList();
  }
}
