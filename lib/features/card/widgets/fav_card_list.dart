import 'package:cardx/common/error_page.dart';
import 'package:cardx/common/loading_page.dart';
import 'package:cardx/constants/appwrite_constants.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/card/controller/card_controller.dart';
import 'package:cardx/features/card/widgets/visit_card.dart';
import 'package:cardx/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavCardList extends ConsumerWidget {
  const FavCardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserAccountProvider).value!.$id;

    return Scaffold(
      body: ref
          .watch(getUserSavedCardsProvider(userId))
          .when(
            data: (cards) {
              final favoriteCards =
                  cards.where((card) => card.isFavorite).toList();
              return ref
                  .watch(getLatestCardProvider)
                  .when(
                    data: (data) {
                      if (data.events.contains(
                        "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.update",
                      )) {
                        final updatedCard = CardModel.fromMap(
                          data.payload,
                        );
                        final index = favoriteCards.indexWhere(
                          (element) => element.id == updatedCard.id,
                        );
                        if (index != -1) {
                          favoriteCards[index] = updatedCard;
                        }
                      } else if (data.events.contains(
                        "databases.*.collections.${AppwriteConstants.cardsCollectionId}.documents.*.delete",
                      )) {
                        final deletedCard = CardModel.fromMap(
                          data.payload,
                        );
                        favoriteCards.removeWhere(
                          (element) => element.id == deletedCard.id,
                        );
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final card = favoriteCards[index];
                          return VisitCard(card: card);
                        },
                        itemCount: favoriteCards.length,
                      );
                    },

                    error:
                        (error, stackTrace) =>
                            ErrorText(errorText: error.toString()),
                    loading: () {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final card = favoriteCards[index];
                          return VisitCard(card: card);
                        },
                        itemCount: favoriteCards.length,
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
