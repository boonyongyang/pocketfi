import 'package:flutter/material.dart';

class TextHighlighterPainter extends CustomPainter {
  final List<TextSpan> textSpans;
  final List<Rect> highlightRects;
  final Paint highlightPaint;

  TextHighlighterPainter({
    required this.textSpans,
    required this.highlightRects,
    required this.highlightPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < textSpans.length; i++) {
      TextPainter textPainter =
          TextPainter(text: textSpans[i], textDirection: TextDirection.ltr);
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      for (int j = 0; j < highlightRects.length; j++) {
        if (textPainter.didExceedMaxLines) {
          return;
        }
        Rect rect = highlightRects[j];
        double rectTop = textPainter
            .getOffsetForCaret(
                TextPosition(offset: rect.top.toInt()), Rect.zero)
            .dy;
        double rectBottom = textPainter
            .getOffsetForCaret(
                TextPosition(offset: rect.bottom.toInt()), Rect.zero)
            .dy;
        canvas.drawRect(
            Rect.fromLTRB(rect.left, rectTop, rect.right, rectBottom),
            highlightPaint);
      }
    }
  }

  @override
  bool shouldRepaint(TextHighlighterPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TextHighlighterPainter oldDelegate) => false;
}
