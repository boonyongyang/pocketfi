import 'dart:ui' show Rect;

class ReceiptTextRect {
  final Rect rect;
  final String text;

  ReceiptTextRect({required this.rect, required this.text});

  ReceiptTextRect.fromJson(Map<String, dynamic> json)
      : rect = Rect.fromLTRB(
          json['left'],
          json['top'],
          json['right'],
          json['bottom'],
        ),
        text = json['text'];

  Map<String, dynamic> toJson() => {
        'left': rect.left,
        'top': rect.top,
        'right': rect.right,
        'bottom': rect.bottom,
        'text': text,
      };
}
