import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/transaction_tile.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DashboardViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/analytics',
              );
            },
            icon: const Icon(Icons.bar_chart),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          vm.addTransaction(
            TransactionModel(
              title: 'Nova Receita',
              value: 200,
              isIncome: true,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Saldo',
                    value: vm.balance,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Receitas',
                    value: vm.totalIncome,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: SummaryCard(
                    title: 'Despesas',
                    value: vm.totalExpense,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transações recentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: vm.transactions.length,
                itemBuilder: (_, index) {
                  return TransactionTile(
                    transaction: vm.transactions[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}