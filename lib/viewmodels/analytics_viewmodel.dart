import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

class AnalyticsViewModel extends ChangeNotifier {
  double expensePercentage(double income, double expense) {
    if (income == 0) return 0;
    return (expense / income).clamp(0.0, 1.0);
  }

  /// Despesas agrupadas por categoria, ordenadas do maior ao menor valor.
  Map<String, double> expensesByCategory(List<TransactionModel> transactions) {
    final Map<String, double> result = {};
    for (final t in transactions.where((t) => !t.isIncome)) {
      result[t.category] = (result[t.category] ?? 0) + t.value;
    }
    final sorted = Map.fromEntries(
      result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  /// Receitas agrupadas por categoria.
  Map<String, double> incomeByCategory(List<TransactionModel> transactions) {
    final Map<String, double> result = {};
    for (final t in transactions.where((t) => t.isIncome)) {
      result[t.category] = (result[t.category] ?? 0) + t.value;
    }
    return result;
  }
}
