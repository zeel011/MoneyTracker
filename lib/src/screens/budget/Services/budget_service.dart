import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackit/src/models/budget_model.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'budgets';

  // Add a new budget
  Future<void> addBudget(BudgetModel budget) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final budgetWithId = budget.copyWith(id: docRef.id);
      await docRef.set(budgetWithId.toMap());
    } catch (e) {
      throw Exception('Failed to add budget: $e');
    }
  }

  // Get budgets for a user
  Stream<List<BudgetModel>> getBudgetStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Update a budget
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(budget.id)
          .update(budget.toMap());
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _firestore.collection(_collection).doc(budgetId).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  // Get active budgets for a specific category
  Stream<List<BudgetModel>> getActiveBudgetsByCategory(
      String userId, String category) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data()))
          .toList();
    });
  }
}
