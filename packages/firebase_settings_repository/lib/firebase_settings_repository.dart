///
library firebase_settings_repository;

import "package:cloud_firestore/cloud_firestore.dart";
import "package:settings_repository/settings_repository.dart";

/// A firebase implementation for the settings repository.
///
/// Uses firestore to store settings using the given [baseCollectionPath].
class FirebaseSettingsRepository implements SettingsRepository {
  /// Create firebase implementation for [SettingsRepository]
  FirebaseSettingsRepository({
    required FirebaseFirestore firestore,
    this.baseCollectionPath = "flutter_settings",
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// The base collection path for the settings in firestore.
  final String baseCollectionPath;

  @override
  Future<void> deleteNamespace(String namespace) async {
    var documentReference = _getDocumentReferenceForNamespace(namespace);

    await documentReference.delete();
  }

  @override
  Future<void> deleteSettingForNamespace(
    String namespace,
    String setting,
  ) async {
    var reference = _getDocumentReferenceForNamespace(namespace);

    await reference.update({
      setting: FieldValue.delete(),
    });
  }

  @override
  Future<SettingsModel> getSettingsAsFuture<T>(String namespace) async {
    var reference = _getDocumentReferenceForNamespace(namespace);

    var snapshot = await reference.get();

    return _mapFromSnapshot(snapshot);
  }

  @override
  Stream<SettingsModel> getSettingsForNamespace(String namespace) {
    var reference = _getDocumentReferenceForNamespace(namespace);

    return reference.snapshots().map(_mapFromSnapshot);
  }

  @override
  Future<void> saveSettingsForNamespace(
    String namespace,
    SettingsModel model,
  ) async {
    var reference = _getDocumentReferenceForNamespace(namespace);

    var oldValue = await reference.get().then(_mapFromSnapshot);

    await reference.set(model.mergeWithPrevious(oldValue));
  }

  @override
  Future<void> saveSingleSettingForNamespace<T>(
    String namespace,
    String setting,
    T value,
  ) async {
    var reference = _getDocumentReferenceForNamespace(namespace);

    await reference.update({
      setting: value,
    });
  }

  SettingsModel _mapFromSnapshot(DocumentSnapshot<SettingsModel> snapshot) {
    if (snapshot.exists) {
      return snapshot.data()!;
    }

    return const SettingsModel(data: {});
  }

  DocumentReference<SettingsModel> _getDocumentReferenceForNamespace(
    String namespace,
  ) =>
      _firestore
          .collection(baseCollectionPath)
          .withConverter(
            fromFirestore: (snapshot, options) => SettingsModel(
              data: snapshot.data()!,
            ),
            toFirestore: (model, options) => model.data,
          )
          .doc(namespace);
}
