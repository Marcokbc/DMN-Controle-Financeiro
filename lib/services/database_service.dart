import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';

// Persistence via SharedPreferences (web-compatible alternative to sqflite).
// The service interface mirrors the sqflite repository pattern so the layer
// can be swapped in a native build without touching ViewModels.
class DatabaseService {
  static const _usersKey = 'cf_users';
  static const _transactionsKey = 'cf_transactions';

  // ── Users ──────────────────────────────────────────────────────────────────

  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _usersKey,
      jsonEncode(users.map((u) => u.toMap()).toList()),
    );
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final users = await _getUsers();
    try {
      return users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns false if the e-mail is already registered.
  Future<bool> createUser(UserModel user) async {
    final users = await _getUsers();
    final exists = users.any(
      (u) => u.email.toLowerCase() == user.email.toLowerCase(),
    );
    if (exists) return false;
    users.add(user);
    await _saveUsers(users);
    return true;
  }

  // ── Transactions ───────────────────────────────────────────────────────────

  Future<List<TransactionModel>> _getAllTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_transactionsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) =>
            TransactionModel.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _saveAll(List<TransactionModel> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _transactionsKey,
      jsonEncode(transactions.map((t) => t.toMap()).toList()),
    );
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final all = await _getAllTransactions();
    return all
        .where((t) => t.userId == userId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> insertTransaction(TransactionModel transaction) async {
    final all = await _getAllTransactions();
    all.add(transaction);
    await _saveAll(all);
  }

  Future<void> deleteTransaction(String id) async {
    final all = await _getAllTransactions();
    all.removeWhere((t) => t.id == id);
    await _saveAll(all);
  }
}
