import 'package:cardx/common/error_page.dart';
import 'package:cardx/features/auth/controller/auth_controller.dart';
import 'package:cardx/features/card/controller/card_controller.dart';
import 'package:cardx/features/card/widgets/visit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavCardList extends ConsumerWidget {
  const FavCardList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserAccountProvider).value!.$id;

    final asyncCards = ref.watch(
      userLikedCardsStreamProvider(userId),
    );

    return Scaffold(
      body: asyncCards.when(
        data: (cards) {
          if (cards.isEmpty) {
            return Center(child: Text("No liked cards found."));
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              final card = cards[index];
              return VisitCard(card: card);
            },
            itemCount: cards.length,
          );
        },
        error: (error, stackTrace) {
          return ErrorText(errorText: error.toString());
        },
        loading: () {
          // Show the last known list while loading
          final previousCards = asyncCards.value ?? [];
          if (previousCards.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final card = previousCards[index];
                return VisitCard(card: card);
              },
              itemCount: previousCards.length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
