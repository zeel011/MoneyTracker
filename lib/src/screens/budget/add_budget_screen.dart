import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trackit/src/constants/color.dart';
import 'package:trackit/src/controllers/budget_controller.dart';
import 'package:trackit/src/models/transaction_model.dart';

class AddBudgetScreen extends StatelessWidget {
  AddBudgetScreen({super.key});

  final BudgetController budgetController = Get.find<BudgetController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final brightness = media.platformBrightness;
    final isDark = brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Budget",
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Budget",
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Create a budget for better financial control",
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Category",
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => DropdownButton<Tag>(
                      value: budgetController.selectedCategory.value,
                      isExpanded: true,
                      underline: SizedBox(),
                      items: Tag.values
                          .map((tag) => DropdownMenuItem(
                                value: tag,
                                child: Row(
                                  children: [
                                    Icon(tagIcons[tag]),
                                    SizedBox(width: 10),
                                    Text(tag.name.toUpperCase()),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          budgetController.setSelectedCategory(value);
                        }
                      },
                    )),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: budgetController.amountController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.headlineSmall!.copyWith(fontSize: 20),
                decoration: InputDecoration(
                  label: Text(
                    "Budget Amount",
                    style: theme.textTheme.bodyLarge,
                  ),
                  prefixIcon: Icon(Icons.currency_rupee_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter budget amount";
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return "Please enter a valid amount";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() => InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: budgetController.startDate.value,
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                );
                                if (date != null) {
                                  budgetController.setStartDate(date);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(
                                          budgetController.startDate.value),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Date",
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() => InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: budgetController.endDate.value,
                                  firstDate: budgetController.startDate.value,
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                );
                                if (date != null) {
                                  budgetController.setEndDate(date);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(
                                          budgetController.endDate.value),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: budgetController.isLoading.value
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                try {
                                  final userId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (userId != null) {
                                    await budgetController.addBudget(userId);
                                    Get.back();
                                    Get.snackbar(
                                      'Success',
                                      'Budget created successfully!',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    e.toString(),
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              }
                            },
                      child: budgetController.isLoading.value
                          ? CircularProgressIndicator(
                              color: isDark ? dPrimaryColor : dSecondaryColor,
                            )
                          : Text(
                              "Create Budget".toUpperCase(),
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isDark ? dSecondaryColor : dPrimaryColor,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
