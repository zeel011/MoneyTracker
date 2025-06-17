// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackit/src/models/transaction_model.dart';

class BudgetModel {
  final String id;
  final String userId;
  final Tag category;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final bool isActive;

  BudgetModel({
    required this.id,
    required this.userId,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'category': category.name,
      'amount': amount,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      category: Tag.values.firstWhere((e) => e.name == map['category']),
      amount: (map['amount'] as num).toDouble(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetModel.fromJson(String source) =>
      BudgetModel.fromMap(json.decode(source) as Map<String, dynamic>);

  BudgetModel copyWith({
    String? id,
    String? userId,
    Tag? category,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
