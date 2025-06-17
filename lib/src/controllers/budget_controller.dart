import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackit/src/models/budget_model.dart';
import 'package:trackit/src/models/transaction_model.dart';
import 'package:trackit/src/screens/budget/Services/budget_service.dart';

class BudgetController extends GetxController {
  static BudgetController get instance => Get.find();
  final BudgetService _budgetService = BudgetService();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) fetchBudgets(userId);
  }

  // Form controllers
  final TextEditingController amountController = TextEditingController();
  final Rx<Tag> selectedCategory = Tag.food.obs;
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().add(Duration(days: 30)).obs;

  // Budgets list
  var budgets = <BudgetModel>[].obs;

  // Set selected category
  void setSelectedCategory(Tag category) {
    selectedCategory.value = category;
  }

  // Set start date
  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  // Set end date
  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  // Clear form
  void clear() {
    amountController.clear();
    selectedCategory.value = Tag.food;
    startDate.value = DateTime.now();
    endDate.value = DateTime.now().add(Duration(days: 30));
  }

  // Fetch budgets
  void fetchBudgets(String userId) {
    _budgetService.getBudgetStream(userId).listen((fetchedBudgets) {
      budgets.value = fetchedBudgets;
      budgets.value = fetchedBudgets
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  // Add budget
  Future<void> addBudget(String userId) async {
    try {
      isLoading.value = true;
      final amount = double.tryParse(amountController.text);
      if (amount == null || amount <= 0) {
        throw Exception('Please enter a valid amount');
      }

      BudgetModel budgetModel = BudgetModel(
        id: '',
        userId: userId,
        category: selectedCategory.value,
        amount: amount,
        startDate: startDate.value,
        endDate: endDate.value,
        createdAt: DateTime.now(),
        isActive: true,
      );

      await _budgetService.addBudget(budgetModel);
      fetchBudgets(userId);
      clear();
    } catch (e) {
      throw Exception('Failed to add budget: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete budget
  Future<void> deleteBudget(String budgetId) async {
    await _budgetService.deleteBudget(budgetId);
  }

  // Get budget progress for a category
  Map<String, dynamic> getBudgetProgress(
      Tag category, List<TransactionModel> transactions) {
    final categoryBudgets =
        budgets.where((b) => b.category == category && b.isActive).toList();
    final categoryExpenses = transactions
        .where((t) => t.tag == category && t.type == TType.expense)
        .fold(0.0, (sum, t) => sum + (double.tryParse(t.amount) ?? 0.0));

    if (categoryBudgets.isEmpty) {
      return {
        'budget': 0.0,
        'spent': categoryExpenses,
        'remaining': 0.0,
        'percentage': 0.0,
      };
    }

    final totalBudget = categoryBudgets.fold(0.0, (sum, b) => sum + b.amount);
    final remaining = totalBudget - categoryExpenses;
    final percentage =
        totalBudget > 0 ? (categoryExpenses / totalBudget) * 100 : 0.0;

    return {
      'budget': totalBudget,
      'spent': categoryExpenses,
      'remaining': remaining,
      'percentage': percentage,
    };
  }

  // Get all budget progress
  Map<Tag, Map<String, dynamic>> getAllBudgetProgress(
      List<TransactionModel> transactions) {
    Map<Tag, Map<String, dynamic>> progress = {};
    for (Tag tag in Tag.values) {
      progress[tag] = getBudgetProgress(tag, transactions);
    }
    return progress;
  }
}
