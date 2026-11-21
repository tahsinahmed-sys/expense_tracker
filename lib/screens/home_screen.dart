
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  double totalExpenses = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // Load expenses and total from SQLite
  Future<void> loadExpenses() async {
    final expenseList =
    await DatabaseHelper.instance.getExpenses();

    final total =
    await DatabaseHelper.instance.getTotalExpenses();

    if (!mounted) return;

    setState(() {
      expenses = expenseList;
      totalExpenses = total;
      isLoading = false;
    });
  }

  // Navigate to Add Expense Screen
  Future<void> navigateToAddExpense() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );

    if (result == true) {
      await loadExpenses();
    }
  }

  // Delete expense
  Future<void> removeExpense(Expense expense) async {
    if (expense.id == null) return;

    await DatabaseHelper.instance.deleteExpense(expense.id!);

    await loadExpenses();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Format amount
  String formatAmount(double amount) {
    return '৳ ${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Total Expenses Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    formatAmount(totalExpenses),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Recent Expenses Heading
            const Text(
              'All Expenses',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Expense List
            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : expenses.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 65,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No expenses yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Tap + to add your first expense',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    elevation: 1,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),

                      leading: CircleAvatar(
                        backgroundColor:
                        Colors.deepPurple.shade50,
                        child: const Icon(
                          Icons.receipt,
                          color: Colors.deepPurple,
                        ),
                      ),

                      title: Text(
                        expense.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      subtitle: Text(
                        formatAmount(expense.amount),
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          removeExpense(expense);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25,right: 10),
        child: FloatingActionButton(
          onPressed: navigateToAddExpense,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 5,
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    );
  }
}
