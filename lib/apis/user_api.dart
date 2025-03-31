import 'package:appwrite/appwrite.dart';
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
        documentId: ID.unique(),
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
}
