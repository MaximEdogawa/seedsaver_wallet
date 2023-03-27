import 'package:flutter/material.dart';

class UnsupportedPlatformWidget extends StatelessWidget {
  const UnsupportedPlatformWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This platform currently is not supported!',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
