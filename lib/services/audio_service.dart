import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/audio.dart';

class AudioService {
  static Future<void> addData(bool insert) async {
    if (insert) {
      FirebaseFirestore db = FirebaseFirestore.instance;

      Audio.inserts.sort((a, b) => a.id.compareTo(b.id));

      Audio.inserts.forEach((audio) async {
        await db.collection('audios').add(audio.toJson());
      });
    }
  }
}
