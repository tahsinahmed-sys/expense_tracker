
class Expense {
  final int? id;
  final String title;
  final double amount;

  const Expense({
    this.id,
    required this.title,
    required this.amount,
  });

  // Convert Expense object into a Map for SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  // Convert SQLite Map into an Expense object.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
