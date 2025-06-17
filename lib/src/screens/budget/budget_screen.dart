import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trackit/src/constants/color.dart';
import 'package:trackit/src/controllers/budget_controller.dart';
import 'package:trackit/src/controllers/transcation_cottroller.dart';
import 'package:trackit/src/models/transaction_model.dart';
import 'package:trackit/src/models/budget_model.dart';
import 'package:trackit/src/screens/budget/add_budget_screen.dart';

class BudgetScreen extends StatelessWidget {
  BudgetScreen({super.key});

  final BudgetController budgetController = Get.put(BudgetController());
  final TranscationCottroller transactionController =
      Get.find<TranscationCottroller>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final brightness = media.platformBrightness;
    final isDark = brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Budget Management",
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => AddBudgetScreen()),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Overview Section (50% of screen)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget Overview",
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: Obx(() {
                      final transactions = transactionController.transactions;
                      final budgetProgress =
                          budgetController.getAllBudgetProgress(transactions);

                      return ListView.builder(
                        itemCount: Tag.values.length,
                        itemBuilder: (context, index) {
                          final tag = Tag.values[index];
                          final progress = budgetProgress[tag]!;

                          return BudgetProgressCard(
                            tag: tag,
                            progress: progress,
                            isDark: isDark,
                            theme: theme,
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Active Budgets Section (50% of screen)
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Budgets",
                    style: theme.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: Obx(() {
                      if (budgetController.budgets.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 60,
                                color: isDark
                                    ? dPrimaryColor
                                    : dSecondaryColor.withOpacity(0.5),
                              ),
                              SizedBox(height: 15),
                              Text(
                                "No budgets set yet",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Tap the + button to create your first budget",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: budgetController.budgets.length,
                        itemBuilder: (context, index) {
                          final budget = budgetController.budgets[index];
                          return BudgetCard(
                            budget: budget,
                            isDark: isDark,
                            theme: theme,
                            onDelete: () =>
                                budgetController.deleteBudget(budget.id),
                          );
                        },
                      );
                    }),
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

class BudgetProgressCard extends StatelessWidget {
  final Tag tag;
  final Map<String, dynamic> progress;
  final bool isDark;
  final ThemeData theme;

  const BudgetProgressCard({
    super.key,
    required this.tag,
    required this.progress,
    required this.isDark,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = progress['percentage'] as double;
    final double budget = progress['budget'] as double;
    final double spent = progress['spent'] as double;
    final double remaining = progress['remaining'] as double;

    Color progressColor = Colors.green;
    if (percentage > 80) progressColor = Colors.orange;
    if (percentage > 100) progressColor = Colors.red;

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? dSecondaryColor : dPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                tagIcons[tag],
                color: isDark ? dPrimaryColor : dSecondaryColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  tag.name.toUpperCase(),
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: theme.textTheme.titleMedium!.copyWith(
                  color: progressColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage > 100 ? 1.0 : percentage / 100,
            backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  Text(
                    "₹${budget.toStringAsFixed(2)}",
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Spent",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  Text(
                    "₹${spent.toStringAsFixed(2)}",
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Remaining",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  Text(
                    "₹${remaining.toStringAsFixed(2)}",
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: remaining >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onDelete;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.isDark,
    required this.theme,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            tagIcons[budget.category],
            color: isDark ? dPrimaryColor : dSecondaryColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.category.name.toUpperCase(),
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "₹${budget.amount.toStringAsFixed(2)}",
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "${DateFormat('MMM dd').format(budget.startDate)} - ${DateFormat('MMM dd').format(budget.endDate)}",
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
