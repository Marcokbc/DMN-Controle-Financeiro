import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/analytics_viewmodel.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardVm =
        Provider.of<DashboardViewModel>(context);

    final analyticsVm =
        Provider.of<AnalyticsViewModel>(context);

    final percentage = analyticsVm.expensePercentage(
      dashboardVm.totalIncome,
      dashboardVm.totalExpense,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análises'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Uso do orçamento',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            LinearProgressIndicator(
              value: percentage,
              minHeight: 25,
            ),

            const SizedBox(height: 20),

            Text(
              '${(percentage * 100).toStringAsFixed(1)}% da receita foi utilizada.',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}