import 'package:uuid/uuid.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final double value;
  final DateTime date;
  final bool isIncome;
  final String category;

  TransactionModel({
    String? id,
    required this.userId,
    required this.title,
    required this.value,
    required this.date,
    required this.isIncome,
    required this.category,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'title': title,
        'value': value,
        'date': date.toIso8601String(),
        'isIncome': isIncome ? 1 : 0,
        'category': category,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'] as String,
        userId: map['userId'] as String,
        title: map['title'] as String,
        value: (map['value'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
        isIncome: (map['isIncome'] as int) == 1,
        category: map['category'] as String? ?? 'Outros',
      );
}
