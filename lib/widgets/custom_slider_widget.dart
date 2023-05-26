import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final Widget child;
  final BuildContext context;

  const CustomSlider({required this.child, required this.context});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 6.0,
        trackShape: const RoundedRectSliderTrackShape(),
        activeTrackColor: Colors.green,
        inactiveTrackColor: Colors.grey.shade300,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10.0,
          pressedElevation: 8.0,
        ),
        thumbColor: Colors.green,
        overlayColor: Colors.green.withOpacity(0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.greenAccent,
        inactiveTickMarkColor: Colors.white,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.black,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      child: child,
    );
  }
}
