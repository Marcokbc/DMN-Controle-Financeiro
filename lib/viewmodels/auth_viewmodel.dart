import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthViewModel extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  UserModel? _currentUser;
  bool _isLoginMode = true;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoginMode => _isLoginMode;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  void toggleMode() {
    _isLoginMode = !_isLoginMode;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _db.getUserByEmail(email.trim());
      if (user == null || user.password != password) {
        _error = 'E-mail ou senha incorretos.';
        _setLoading(false);
        return false;
      }
      _currentUser = user;
      _error = null;
      _setLoading(false);
      return true;
    } catch (_) {
      _error = 'Erro ao fazer login. Tente novamente.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      final newUser = UserModel(
        id: const Uuid().v4(),
        name: name.trim(),
        email: email.trim(),
        password: password,
      );
      final created = await _db.createUser(newUser);
      if (!created) {
        _error = 'Este e-mail já está cadastrado.';
        _setLoading(false);
        return false;
      }
      _currentUser = newUser;
      _error = null;
      _setLoading(false);
      return true;
    } catch (_) {
      _error = 'Erro ao cadastrar. Tente novamente.';
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _isLoginMode = true;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
