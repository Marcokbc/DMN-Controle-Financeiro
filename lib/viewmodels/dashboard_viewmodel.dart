import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../services/database_service.dart';

enum TransactionFilter { all, income, expense }

class DashboardViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _userId;
  TransactionFilter _filter = TransactionFilter.all;

  List<TransactionModel> get transactions {
    switch (_filter) {
      case TransactionFilter.income:
        return _transactions.where((t) => t.isIncome).toList();
      case TransactionFilter.expense:
        return _transactions.where((t) => !t.isIncome).toList();
      case TransactionFilter.all:
        return List.unmodifiable(_transactions);
    }
  }

  bool get isLoading => _isLoading;
  TransactionFilter get filter => _filter;

  double get totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.value);

  double get totalExpense => _transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, t) => sum + t.value);

  double get balance => totalIncome - totalExpense;

  void setFilter(TransactionFilter f) {
    _filter = f;
    notifyListeners();
  }

  Future<void> loadTransactions(String userId) async {
    _userId = userId;
    _isLoading = true;
    notifyListeners();
    _transactions = await _db.getTransactions(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.insertTransaction(transaction);
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await _db.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clear() {
    _transactions = [];
    _userId = null;
    _filter = TransactionFilter.all;
    notifyListeners();
  }

  List<TransactionModel> get allTransactions =>
      List.unmodifiable(_transactions);
}
