import '../models/transaction_model.dart';

class FakeDatabaseService {
  static List<TransactionModel> transactions = [
    TransactionModel(
      title: 'Salário',
      value: 3000,
      isIncome: true,
    ),
    TransactionModel(
      title: 'Mercado',
      value: 250,
      isIncome: false,
    ),
    TransactionModel(
      title: 'Freelance',
      value: 500,
      isIncome: true,
    ),
  ];
}