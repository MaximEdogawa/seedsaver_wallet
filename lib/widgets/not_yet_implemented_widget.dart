import 'package:flutter/material.dart';

class NotYetImplementedCard extends StatelessWidget {
  const NotYetImplementedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/seedsaver_store_logo_big.png'),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Coming',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Card(
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    // Make sure that the compound word wraps correctly when the window
                    // is too narrow.
                    child: MergeSemantics(
                      child: Wrap(
                        children: [
                          Text(
                            "Soon™",
                            style: style.copyWith(fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
