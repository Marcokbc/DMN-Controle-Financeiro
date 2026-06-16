import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/analytics_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashVm = context.watch<DashboardViewModel>();
    final analyticsVm = context.watch<AnalyticsViewModel>();
    final currencyFmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final percentage = analyticsVm.expensePercentage(
      dashVm.totalIncome,
      dashVm.totalExpense,
    );
    final expensesByCategory =
        analyticsVm.expensesByCategory(dashVm.allTransactions);
    final incomeByCategory =
        analyticsVm.incomeByCategory(dashVm.allTransactions);

    final totalExpense = dashVm.totalExpense;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Análises'),
      ),
      body: dashVm.allTransactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded,
                      size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text(
                    'Nenhuma transação registrada',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Uso do orçamento ───────────────────────────────────────
                  _SectionCard(
                    title: 'Uso do Orçamento',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(percentage * 100).toStringAsFixed(1)}% da receita gasto',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              currencyFmt.format(dashVm.totalExpense),
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: percentage,
                            minHeight: 20,
                            backgroundColor: Colors.green[100],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentage > 0.9
                                  ? Colors.red
                                  : percentage > 0.7
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Receita: ${currencyFmt.format(dashVm.totalIncome)}',
                              style: TextStyle(
                                  color: Colors.green[700], fontSize: 13),
                            ),
                            Text(
                              'Saldo: ${currencyFmt.format(dashVm.balance)}',
                              style: TextStyle(
                                  color: Colors.blue[700], fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Despesas por categoria ─────────────────────────────────
                  if (expensesByCategory.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Despesas por Categoria',
                      child: Column(
                        children: expensesByCategory.entries.map((entry) {
                          final pct = totalExpense > 0
                              ? entry.value / totalExpense
                              : 0.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      currencyFmt.format(entry.value),
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: pct,
                                          minHeight: 10,
                                          backgroundColor: Colors.red[50],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.red.shade400),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(pct * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Receitas por categoria ─────────────────────────────────
                  if (incomeByCategory.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Receitas por Categoria',
                      child: Column(
                        children: incomeByCategory.entries.map((entry) {
                          final totalIncome = dashVm.totalIncome;
                          final pct =
                              totalIncome > 0 ? entry.value / totalIncome : 0.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      currencyFmt.format(entry.value),
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: pct,
                                          minHeight: 10,
                                          backgroundColor: Colors.green[50],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.green.shade600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(pct * 100).toStringAsFixed(0)}%',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Resumo numérico ────────────────────────────────────────
                  _SectionCard(
                    title: 'Resumo',
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Total de transações',
                          value:
                              '${dashVm.allTransactions.length}',
                          icon: Icons.receipt_long,
                          color: Colors.blue,
                        ),
                        _SummaryRow(
                          label: 'Entradas',
                          value: currencyFmt.format(dashVm.totalIncome),
                          icon: Icons.arrow_downward,
                          color: Colors.green,
                        ),
                        _SummaryRow(
                          label: 'Saídas',
                          value: currencyFmt.format(dashVm.totalExpense),
                          icon: Icons.arrow_upward,
                          color: Colors.red,
                        ),
                        _SummaryRow(
                          label: 'Saldo',
                          value: currencyFmt.format(dashVm.balance),
                          icon: Icons.account_balance_wallet,
                          color: dashVm.balance >= 0 ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
