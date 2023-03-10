import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

const double kCardHeight = 225;
const double kCardWidth = 356;

const double kSpaceBetweenCard = 24;
const double kSpaceBetweenUnselectCard = 32;
const double kSpaceUnselectedCardToTop = 320;

const Duration kAnimationDuration = Duration(milliseconds: 245);

class VaultCardData {
  VaultCardData({required this.backgroundColor});
  final Color backgroundColor;
}

class VaultPage extends StatefulWidget {
  const VaultPage({
    Key? key,
    this.cardsData = const [],
    this.space = kSpaceBetweenCard,
  }) : super(key: key);

  final List<VaultCardData> cardsData;
  final double space;

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  int? selectedCardIndex;

  late final List<VaultCard> vaultCards;

  @override
  void initState() {
    super.initState();

    vaultCards = widget.cardsData
        .map((data) => VaultCard(
              backgroundColor: data.backgroundColor,
            ))
        .toList();
  }

  int toUnselectedCardPositionIndex(int indexInAllList) {
    if (selectedCardIndex != null) {
      if (indexInAllList < selectedCardIndex!) {
        return indexInAllList;
      } else {
        return indexInAllList - 1;
      }
    } else {
      throw 'Wrong usage';
    }
  }

  double _getCardTopPosititoned(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return widget.space;
      } else {
        /// Space from top to place put unselect cards.
        return kSpaceUnselectedCardToTop +
            toUnselectedCardPositionIndex(index) * kSpaceBetweenUnselectCard;
      }
    } else {
      /// Top first emptySpace + CardSpace + emptySpace + ...
      return widget.space + index * kCardHeight + index * widget.space;
    }
  }

  double _getCardScale(int index, isSelected) {
    if (selectedCardIndex != null) {
      if (isSelected) {
        return 1.0;
      } else {
        int totalUnselectCard = vaultCards.length - 1;
        return 1.0 -
            (totalUnselectCard - toUnselectedCardPositionIndex(index) - 1) *
                0.05;
      }
    } else {
      return 1.0;
    }
  }

  void unSelectCard() {
    setState(() {
      selectedCardIndex = null;
    });
  }

  double totalHeightTotalCard() {
    if (selectedCardIndex == null) {
      final totalCard = vaultCards.length;
      return widget.space * (totalCard + 1) + kCardHeight * totalCard;
    } else {
      return kSpaceUnselectedCardToTop +
          kCardHeight +
          (vaultCards.length - 2) * kSpaceBetweenUnselectCard +
          kSpaceBetweenCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              AnimatedContainer(
                duration: kAnimationDuration,
                height: totalHeightTotalCard(),
                width: mediaQuery.size.width,
              ),
              for (int i = 0; i < vaultCards.length; i++)
                AnimatedPositioned(
                  top: _getCardTopPosititoned(i, i == selectedCardIndex),
                  duration: kAnimationDuration,
                  child: AnimatedScale(
                    scale: _getCardScale(i, i == selectedCardIndex),
                    duration: kAnimationDuration,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCardIndex = i;
                        });
                      },
                      child: vaultCards[i],
                    ),
                  ),
                ),
              if (selectedCardIndex != null)
                Positioned.fill(
                    child: GestureDetector(
                  onVerticalDragEnd: (_) {
                    unSelectCard();
                  },
                  onVerticalDragStart: (_) {
                    unSelectCard();
                  },
                ))
            ],
          ),
        ),
      ),
    );
  }
}

class VaultCard extends StatelessWidget {
  const VaultCard({
    Key? key,
    required this.backgroundColor,
  }) : super(key: key);

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CreditCardWidget(
        cardNumber: '374245455400126',
        expiryDate: '05/2023',
        cardHolderName: 'Leo',
        cvvCode: '123',
        showBackView: false,
        isSwipeGestureEnabled: true,
        height: kCardHeight,
        width: kCardWidth,
        cardBgColor: backgroundColor,
        onCreditCardWidgetChange: (_) {},
      ),
    );
  }
}
