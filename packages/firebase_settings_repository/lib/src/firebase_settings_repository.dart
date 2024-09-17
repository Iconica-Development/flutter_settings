import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:settings_repository_interface/settings_repository_interface.dart';

class FirebaseSettingsRepository implements SettingsRepositoryInterface {
  final String usersCollection;
  Map<String, dynamic> _settingsMap = {};

  FirebaseSettingsRepository({
    this.usersCollection = 'users',
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore firestore;

  @override
  Future<void> loadSettings() async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection(usersCollection).doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        _settingsMap = snapshot.data()!['settings'] ?? {};
      } else {
        _settingsMap = {};
      }
    } catch (e) {
      print('Error loading settings: $e');
      throw Exception('Failed to load settings');
    }
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    try {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      await firestore
          .collection(usersCollection)
          .doc(userId)
          .set({'settings': settings}, SetOptions(merge: true));

      _settingsMap.addAll(settings);
    } catch (e) {
      print('Error saving settings: $e');
      throw Exception('Failed to save settings');
    }
  }

  @override
  Map<String, dynamic> get settings => _settingsMap;
}
