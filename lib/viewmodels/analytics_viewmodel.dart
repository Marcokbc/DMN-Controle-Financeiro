import 'package:flutter/material.dart';

class AnalyticsViewModel extends ChangeNotifier {
  double expensePercentage(double income, double expense) {
    if (income == 0) return 0;
    return expense / income;
  }
}