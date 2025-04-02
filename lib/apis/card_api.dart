import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cardx/constants/constants.dart';
import 'package:cardx/core/core.dart';
import 'package:cardx/models/card_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';

final cardAPIProvider = Provider((ref) {
  final database = ref.watch(appwriteDatabaseProvider);
  final realTime = ref.watch(appwriteRealTimeProvider);
  return CardApi(database: database, realTime: realTime);
});

abstract class ICardApi {
  FutureEither<Document> saveCard(CardModel card);
  Future<List<Document>> getUserSavedCards(String uid);
  Stream<RealtimeMessage> getLatestCard();
  Stream<RealtimeMessage> getLatestLikedCard(String uid);
  FutureEither<Document> likeCard(CardModel cardModel);
  Future<List<Document>> getLikedCards(String uid);
  Stream<List<CardModel>> getLikedCardsStream(String userId);
}

class CardApi implements ICardApi {
  final Databases _db;
  final Realtime _realtime;
  CardApi({required Databases database, required Realtime realTime})
    : _realtime = realTime,
      _db = database,
      super();

  // saving cards api call
  @override
  FutureEither<Document> saveCard(CardModel card) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cardsCollectionId,
        documentId: ID.unique(),
        data: card.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  // getting all cards,  user has saved api call
  @override
  Future<List<Document>> getUserSavedCards(String uid) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cardsCollectionId,
        queries: [
          Query.orderDesc("createdAt"),
          Query.equal("uid", uid),
        ],
      );
      return documents.documents;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<RealtimeMessage> getLatestCard() {
    final channel =
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.cardsCollectionId}.documents';
    final realTimeMessage = _realtime.subscribe([channel]).stream;
    return realTimeMessage;
  }

  @override
  Stream<RealtimeMessage> getLatestLikedCard(String uid) {
    final channel =
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.cardsCollectionId}.documents';
    final realTimeMessage = _realtime.subscribe([channel]).stream;

    return realTimeMessage.where((message) {
      final data = message.payload;
      return data['isFavorite'] == true && data['uid'] == uid;
    });
  }

  @override
  FutureEither<Document> likeCard(CardModel cardModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cardsCollectionId,
        documentId: cardModel.id,
        data: {"isFavorite": cardModel.isFavorite},
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? "Unknown", stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getLikedCards(String uid) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cardsCollectionId,
        queries: [
          Query.equal("uid", uid),
          Query.equal("isFavorite", true),
        ],
      );
      return documents.documents;
    } on AppwriteException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Stream<List<CardModel>> getLikedCardsStream(String userId) async* {
    final channel =
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.cardsCollectionId}.documents';

    final controller = StreamController<List<CardModel>>();
    final List<CardModel> accumulatedCards = [];

    // Fetch the initial list of liked cards
    try {
      final initialDocuments = await getLikedCards(userId);
      accumulatedCards.addAll(
        initialDocuments.map((doc) => CardModel.fromMap(doc.data)),
      );
      controller.add(
        List.from(accumulatedCards),
      ); // Emit the initial list
    } catch (e) {
      controller.addError(
        e,
      ); // Handle errors during the initial fetch
    }

    // Listen to real-time updates
    _realtime.subscribe([channel]).stream.listen((message) {
      if (message.payload is Map<String, dynamic>) {
        final data = message.payload as Map<String, dynamic>;
        final card = CardModel.fromMap(data);

        if (data['isFavorite'] == true && data['uid'] == userId) {
          // Add or update the card in the list
          final index = accumulatedCards.indexWhere(
            (c) => c.id == card.id,
          );
          if (index != -1) {
            accumulatedCards[index] = card; // Update existing card
          } else {
            accumulatedCards.add(card); // Add new card
          }
        } else if (data['isFavorite'] == false &&
            data['uid'] == userId) {
          // Remove the card from the list if it is disliked
          accumulatedCards.removeWhere((c) => c.id == card.id);
        }

        // Emit the updated list
        controller.add(List.from(accumulatedCards));
      }
    });

    yield* controller.stream;
  }
}
