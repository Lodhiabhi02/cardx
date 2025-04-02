import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cardx/constants/appwrite_constants.dart';
import 'package:cardx/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageApiProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageApi(storgae: storage);
});

class StorageApi {
  final Storage _storage;
  StorageApi({required Storage storgae})
    : _storage = storgae,
      super();

  Future<String> uploadImage(File file) async {
    try {
      String imageLink = "";
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.bucketId,
        fileId: ID.unique(),
        file: InputFile.fromBytes(
          bytes: await file.readAsBytes(),
          filename: file.path.split('/').last,
        ),
      );
      imageLink = AppwriteConstants.imageUrl(uploadedImage.$id);
      return imageLink;
    } on AppwriteException catch (e) {
      print("exception ${e.message}");
      return e.message ?? "unknown";
    }
  }
}
