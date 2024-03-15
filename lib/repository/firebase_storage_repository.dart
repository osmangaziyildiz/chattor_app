import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider = Provider((ref) {
  return FirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance);
});

class FirebaseStorageRepository {
  FirebaseStorageRepository({required this.firebaseStorage});

  final FirebaseStorage firebaseStorage;

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
