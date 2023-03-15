// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;

@immutable
class Receipt {
  final String id;
  final double amount;
  final DateTime date;
  final String categoryName;
  final String image;
  final String? merchant;
  final String? scannedText;

  const Receipt({
    required this.id,
    required this.amount,
    required this.date,
    required this.categoryName,
    required this.image,
    this.merchant,
    this.scannedText,
  });

  Receipt.fromJson({
    required String id,
    required Map<String, dynamic> json,
  }) : this(
          id: id,
          amount: json['amount'],
          date: json['date'],
          categoryName: json['category'],
          image: json['image'],
          merchant: json['merchant'],
          scannedText: json['scannedText'],
        );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'date': date,
        'category': categoryName,
        'image': image,
        'merchant': merchant,
        'scannedText': scannedText,
      };

  Receipt copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? categoryName,
    String? image,
    String? merchant,
    String? scannedText,
  }) {
    return Receipt(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryName: categoryName ?? this.categoryName,
      image: image ?? this.image,
      merchant: merchant ?? this.merchant,
      scannedText: scannedText ?? this.scannedText,
    );
  }
}
