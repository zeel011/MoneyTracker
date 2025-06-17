import 'package:get/get.dart';
import 'package:trackit/src/models/transaction_model.dart';

class ReportsController extends GetxController {
  static ReportsController get instance => Get.find();

  // Generate monthly report
  Map<String, dynamic> generateMonthlyReport(
      List<TransactionModel> transactions, int year, int month) {
    final monthlyTransactions = transactions.where((t) {
      return t.createdAt.year == year && t.createdAt.month == month;
    }).toList();

    double totalIncome = 0.0;
    double totalExpense = 0.0;
    Map<Tag, double> categoryExpenses = {};
    Map<Tag, double> categoryIncome = {};

    // Initialize category maps
    for (Tag tag in Tag.values) {
      categoryExpenses[tag] = 0.0;
      categoryIncome[tag] = 0.0;
    }

    for (var transaction in monthlyTransactions) {
      double amount = double.tryParse(transaction.amount) ?? 0.0;

      if (transaction.type == TType.income) {
        totalIncome += amount;
        categoryIncome[transaction.tag] =
            (categoryIncome[transaction.tag] ?? 0.0) + amount;
      } else {
        totalExpense += amount;
        categoryExpenses[transaction.tag] =
            (categoryExpenses[transaction.tag] ?? 0.0) + amount;
      }
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netAmount': totalIncome - totalExpense,
      'categoryExpenses': categoryExpenses,
      'categoryIncome': categoryIncome,
      'transactionCount': monthlyTransactions.length,
      'incomeCount':
          monthlyTransactions.where((t) => t.type == TType.income).length,
      'expenseCount':
          monthlyTransactions.where((t) => t.type == TType.expense).length,
    };
  }

  // Generate yearly report
  Map<String, dynamic> generateYearlyReport(
      List<TransactionModel> transactions, int year) {
    final yearlyTransactions =
        transactions.where((t) => t.createdAt.year == year).toList();

    Map<int, Map<String, dynamic>> monthlyData = {};

    // Initialize monthly data
    for (int month = 1; month <= 12; month++) {
      monthlyData[month] = {
        'income': 0.0,
        'expense': 0.0,
        'net': 0.0,
        'count': 0,
      };
    }

    for (var transaction in yearlyTransactions) {
      double amount = double.tryParse(transaction.amount) ?? 0.0;
      int month = transaction.createdAt.month;

      if (transaction.type == TType.income) {
        monthlyData[month]!['income'] =
            (monthlyData[month]!['income'] as double) + amount;
      } else {
        monthlyData[month]!['expense'] =
            (monthlyData[month]!['expense'] as double) + amount;
      }

      monthlyData[month]!['count'] = (monthlyData[month]!['count'] as int) + 1;
    }

    // Calculate net amounts
    for (int month = 1; month <= 12; month++) {
      monthlyData[month]!['net'] = (monthlyData[month]!['income'] as double) -
          (monthlyData[month]!['expense'] as double);
    }

    double totalYearlyIncome = monthlyData.values
        .fold(0.0, (sum, data) => sum + (data['income'] as double));
    double totalYearlyExpense = monthlyData.values
        .fold(0.0, (sum, data) => sum + (data['expense'] as double));

    return {
      'year': year,
      'totalIncome': totalYearlyIncome,
      'totalExpense': totalYearlyExpense,
      'netAmount': totalYearlyIncome - totalYearlyExpense,
      'monthlyData': monthlyData,
      'transactionCount': yearlyTransactions.length,
    };
  }

  // Generate category-wise report
  Map<String, dynamic> generateCategoryReport(
      List<TransactionModel> transactions,
      {DateTime? startDate,
      DateTime? endDate}) {
    List<TransactionModel> filteredTransactions = transactions;

    if (startDate != null && endDate != null) {
      filteredTransactions = transactions.where((t) {
        return t.createdAt.isAfter(startDate.subtract(Duration(days: 1))) &&
            t.createdAt.isBefore(endDate.add(Duration(days: 1)));
      }).toList();
    }

    Map<Tag, Map<String, dynamic>> categoryData = {};

    // Initialize category data
    for (Tag tag in Tag.values) {
      categoryData[tag] = {
        'totalIncome': 0.0,
        'totalExpense': 0.0,
        'transactionCount': 0,
        'averageAmount': 0.0,
        'largestTransaction': 0.0,
        'smallestTransaction': double.infinity,
      };
    }

    for (var transaction in filteredTransactions) {
      double amount = double.tryParse(transaction.amount) ?? 0.0;
      Tag tag = transaction.tag;

      if (transaction.type == TType.income) {
        categoryData[tag]!['totalIncome'] =
            (categoryData[tag]!['totalIncome'] as double) + amount;
      } else {
        categoryData[tag]!['totalExpense'] =
            (categoryData[tag]!['totalExpense'] as double) + amount;
      }

      categoryData[tag]!['transactionCount'] =
          (categoryData[tag]!['transactionCount'] as int) + 1;

      // Track largest and smallest transactions
      if (amount > (categoryData[tag]!['largestTransaction'] as double)) {
        categoryData[tag]!['largestTransaction'] = amount;
      }
      if (amount < (categoryData[tag]!['smallestTransaction'] as double)) {
        categoryData[tag]!['smallestTransaction'] = amount;
      }
    }

    // Calculate averages and handle edge cases
    for (Tag tag in Tag.values) {
      int count = categoryData[tag]!['transactionCount'] as int;
      if (count > 0) {
        double totalAmount = (categoryData[tag]!['totalIncome'] as double) +
            (categoryData[tag]!['totalExpense'] as double);
        categoryData[tag]!['averageAmount'] = totalAmount / count;
      }

      if ((categoryData[tag]!['smallestTransaction'] as double) ==
          double.infinity) {
        categoryData[tag]!['smallestTransaction'] = 0.0;
      }
    }

    return {
      'categoryData': categoryData,
      'totalTransactions': filteredTransactions.length,
      'period': startDate != null && endDate != null
          ? '${startDate.toString().substring(0, 10)} to ${endDate.toString().substring(0, 10)}'
          : 'All time',
    };
  }

  // Get spending trends
  Map<String, dynamic> getSpendingTrends(
      List<TransactionModel> transactions, int months) {
    Map<String, double> monthlyExpenses = {};
    DateTime now = DateTime.now();

    // Initialize last N months
    for (int i = months - 1; i >= 0; i--) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      String monthKey =
          '${month.year}-${month.month.toString().padLeft(2, '0')}';
      monthlyExpenses[monthKey] = 0.0;
    }

    // Calculate expenses for each month
    for (var transaction in transactions) {
      if (transaction.type == TType.expense) {
        DateTime transactionDate = transaction.createdAt;
        String monthKey =
            '${transactionDate.year}-${transactionDate.month.toString().padLeft(2, '0')}';

        if (monthlyExpenses.containsKey(monthKey)) {
          double amount = double.tryParse(transaction.amount) ?? 0.0;
          monthlyExpenses[monthKey] =
              (monthlyExpenses[monthKey] ?? 0.0) + amount;
        }
      }
    }

    return {
      'monthlyExpenses': monthlyExpenses,
      'trend': calculateTrend(monthlyExpenses.values.toList()),
    };
  }

  // Calculate trend (positive = increasing, negative = decreasing)
  double calculateTrend(List<double> values) {
    if (values.length < 2) return 0.0;

    double sum = 0.0;
    for (int i = 1; i < values.length; i++) {
      sum += values[i] - values[i - 1];
    }
    return sum / (values.length - 1);
  }
}
