import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../services/fake_database_service.dart';

class DashboardViewModel extends ChangeNotifier {
  List<TransactionModel> get transactions =>
      FakeDatabaseService.transactions;

  double get totalIncome => transactions
      .where((e) => e.isIncome)
      .fold(0, (a, b) => a + b.value);

  double get totalExpense => transactions
      .where((e) => !e.isIncome)
      .fold(0, (a, b) => a + b.value);

  double get balance => totalIncome - totalExpense;

  void addTransaction(TransactionModel transaction) {
    FakeDatabaseService.transactions.add(transaction);
    notifyListeners();
  }
}