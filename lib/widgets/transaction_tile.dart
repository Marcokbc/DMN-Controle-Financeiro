import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  static const _categoryIcons = <String, IconData>{
    'Salário': Icons.work_outline,
    'Freelance': Icons.laptop_outlined,
    'Investimento': Icons.trending_up,
    'Presente': Icons.card_giftcard_outlined,
    'Alimentação': Icons.restaurant_outlined,
    'Transporte': Icons.directions_car_outlined,
    'Moradia': Icons.home_outlined,
    'Saúde': Icons.local_hospital_outlined,
    'Lazer': Icons.sports_esports_outlined,
    'Educação': Icons.school_outlined,
    'Outros': Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? Colors.green : Colors.red;
    final currencyFmt =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final icon = _categoryIcons[transaction.category] ?? Icons.attach_money;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          '${transaction.category} · '
          '${DateFormat('dd/MM/yyyy').format(transaction.date)}',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.isIncome ? '+' : '-'} ${currencyFmt.format(transaction.value)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              color: Colors.grey[400],
              tooltip: 'Excluir',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
