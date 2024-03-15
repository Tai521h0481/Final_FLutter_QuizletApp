import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final double tabWidth;

  CustomTabIndicator({required this.tabWidth});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(tabWidth: tabWidth);
  }
}

class _CustomPainter extends BoxPainter {
  final double tabWidth;

  _CustomPainter({required this.tabWidth});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = const Color(0xFF4654FC)
      ..style = PaintingStyle.fill;

    final double indicatorWidth = tabWidth;
    final double horizontalOffset = (configuration.size!.width - indicatorWidth) / 2;

    final Rect rect = Rect.fromLTWH(
      offset.dx + horizontalOffset,
      configuration.size!.height - 5,
      indicatorWidth,
      3,
    );
    canvas.drawRect(rect, paint);
  }
}