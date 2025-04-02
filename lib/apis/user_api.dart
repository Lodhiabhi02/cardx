import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:cardx/constants/appwrite_constants.dart';
import 'package:cardx/core/core.dart';
import 'package:cardx/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserApi(database: db);
});

abstract class IUserApi {
  FutureEitherVoid saveUserData(UserModel usermodel);
  Future<model.Document> getUserData(String uid);
  FutureEitherVoid updateUserData(UserModel userModel);
  FutureEitherVoid addCardToUserData(UserModel userModel);
}

class UserApi implements IUserApi {
  final Databases _db;
  UserApi({required Databases database}) : _db = database;
  @override
  FutureEitherVoid saveUserData(UserModel usermodel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: usermodel.uid,
        data: usermodel.toMap(),
      );

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? "Some unexpected error ", stackTrace),
      );
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) async {
    return await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: uid,
    );
  }

  // this is for updating the profile pic
  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEitherVoid addCardToUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: {"savedCards": userModel.savedCards},
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    }
  }
}
