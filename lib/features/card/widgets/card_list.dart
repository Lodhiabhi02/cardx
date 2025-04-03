import 'package:cardx/common/error_page.dart';
import 'package:cardx/common/loading_page.dart';
import 'package:cardx/constants/appwrite_constants.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/card/controller/card_controller.dart';
import 'package:cardx/features/card/widgets/visit_card.dart';
import 'package:cardx/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardList extends ConsumerWidget {
  const CardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(
            getUserSavedCardsProvider(
              ref.watch(currentUserAccountProvider).value!.$id,
            ),
          )
          .when(
            data: (cards) {
              return ref
                  .watch(getLatestCardProvider)
                  .when(
                    data: (data) {
                      if (data.events.contains(
                        "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.create",
                      )) {
                        final newCard = CardModel.fromMap(
                          data.payload,
                        );
                        // Prevent duplicate insertion
                        if (!cards.any(
                          (card) => card.id == newCard.id,
                        )) {
                          cards.insert(0, newCard);
                        }
                      } else if (data.events.contains(
                        "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.update",
                      )) {
                        final updatedCard = CardModel.fromMap(
                          data.payload,
                        );
                        final index = cards.indexWhere(
                          (element) => element.id == updatedCard.id,
                        );
                        if (index != -1) {
                          cards[index] = updatedCard;
                        }
                      } else if (data.events.contains(
                        "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.delete",
                      )) {
                        final deletedCard = CardModel.fromMap(
                          data.payload,
                        );
                        cards.removeWhere(
                          (element) => element.id == deletedCard.id,
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return VisitCard(card: card);
                        },
                        itemCount: cards.length,
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            ErrorText(errorText: error.toString()),
                    loading: () {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return VisitCard(card: card);
                        },
                        itemCount: cards.length,
                      );
                    },
                  );
            },
            error:
                (error, stackTrace) =>
                    ErrorText(errorText: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
