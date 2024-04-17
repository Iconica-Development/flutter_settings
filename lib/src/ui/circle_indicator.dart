import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class CircleIndicator extends StatelessWidget {
  const CircleIndicator({
    required this.currentPageNotifier,
    required this.number,
    super.key,
  });

  final ValueNotifier<int> currentPageNotifier;
  final int number;

  @override
  Widget build(BuildContext context) => CirclePageIndicator(
        size: 14.0,
        selectedSize: 14.0,
        dotColor: const Color.fromRGBO(91, 193, 210, 0.3),
        selectedDotColor: Colors.blue[300],
        itemCount: number,
        currentPageNotifier: currentPageNotifier,
      );
}
