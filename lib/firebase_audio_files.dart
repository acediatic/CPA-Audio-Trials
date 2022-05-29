import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAudio {
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  static final FirebaseAudio _singleton = FirebaseAudio._internal();

  factory FirebaseAudio() {
    return _singleton;
  }
  FirebaseAudio._internal();

  Future<String> _getAudioFromString(String filePath) async {
    final pathReference = storageRef.child(filePath);
    return pathReference.getDownloadURL();
  }

  Future<String> getSAudioFromPath(String filePath) {
    return _getAudioFromString("S/$filePath");
  }
}
