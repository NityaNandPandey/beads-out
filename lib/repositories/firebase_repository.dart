import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firebase_constants.dart';
import '../core/logger/app_logger.dart';
import '../models/level_model.dart';
import '../models/player_progress.dart';
import '../models/settings_model.dart';
import '../services/firebase_service.dart';

class FirebaseRepository {
  FirebaseRepository(this._firebaseService);

  final FirebaseService _firebaseService;

  CollectionReference<Map<String, dynamic>>? get _usersCollection {
    return _firebaseService.firestore
        ?.collection(FirebaseConstants.usersCollection);
  }

  Future<void> ensureUserDocuments(String uid) async {
    final users = _usersCollection;
    if (users == null) return;

    try {
      await _firebaseService.refreshAuthToken();

      final userRef = users.doc(uid);
      final dataRef = userRef.collection('data');
      final progressSnap =
          await dataRef.doc(FirebaseConstants.progressDoc).get();

      if (progressSnap.exists) return;

      await userRef.set({
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await Future.wait([
        dataRef.doc(FirebaseConstants.profileDoc).set({
          'displayName': 'Player',
          'createdAt': FieldValue.serverTimestamp(),
        }),
        dataRef.doc(FirebaseConstants.progressDoc).set(
              const PlayerProgress().toJson(),
            ),
        dataRef.doc(FirebaseConstants.settingsDoc).set(
              const SettingsModel().toJson(),
            ),
      ]);

      AppLogger.info('Firestore user documents created for $uid');
    } catch (error, stackTrace) {
      AppLogger.error('ensureUserDocuments failed', error, stackTrace);
    }
  }

  Future<PlayerProgress?> fetchProgress(String uid) async {
    return _fetchDocument(
      uid,
      FirebaseConstants.progressDoc,
      PlayerProgress.fromJson,
    );
  }

  Future<SettingsModel?> fetchSettings(String uid) async {
    return _fetchDocument(
      uid,
      FirebaseConstants.settingsDoc,
      SettingsModel.fromJson,
    );
  }

  Future<T?> _fetchDocument<T>(
    String uid,
    String docId,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final users = _usersCollection;
    if (users == null) return null;

    try {
      await _firebaseService.refreshAuthToken();

      final doc =
          await users.doc(uid).collection('data').doc(docId).get();

      if (!doc.exists || doc.data() == null) return null;
      return fromJson(doc.data()!);
    } catch (error, stackTrace) {
      AppLogger.error('Failed to fetch $docId', error, stackTrace);
      return null;
    }
  }

  Future<void> syncProgress(String uid, PlayerProgress progress) async {
    await _syncDocument(uid, FirebaseConstants.progressDoc, progress.toJson());
  }

  Future<void> syncSettings(String uid, SettingsModel settings) async {
    await _syncDocument(
      uid,
      FirebaseConstants.settingsDoc,
      settings.toJson(),
    );
  }

  Future<void> _syncDocument(
    String uid,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final users = _usersCollection;
    if (users == null) return;

    try {
      await _firebaseService.refreshAuthToken();

      await users.doc(uid).collection('data').doc(docId).set(
            data,
            SetOptions(merge: true),
          );
    } catch (error, stackTrace) {
      AppLogger.error('Failed to sync $docId', error, stackTrace);
    }
  }

  Future<List<LevelModel>> fetchLevels() async {
    final firestore = _firebaseService.firestore;
    if (firestore == null) return [];

    try {
      await _firebaseService.refreshAuthToken();

      final snapshot = await firestore
          .collection(FirebaseConstants.levelsCollection)
          .orderBy('levelNumber')
          .get();

      return snapshot.docs
          .map((doc) => LevelModel.fromJson(doc.data()))
          .toList();
    } catch (error, stackTrace) {
      AppLogger.error('Failed to fetch levels', error, stackTrace);
      return [];
    }
  }
}
