class ExpenseModel {
  final String expenseId;
  final String tripId;
  final String name;
  final double paid;
  final double cost;
  final String currency;
  final String category;
  final DateTime dateTimeAdded;
  final DateTime datePaid;
  final String type;
  final List<String> tags;
  final String notes;
  final String image;

  ExpenseModel({
    required this.name,
    required this.expenseId,
    required this.tripId,
    required this.paid,
    required this.cost,
    required this.dateTimeAdded,
    required this.datePaid,
    required this.currency,
    this.tags = const [],
    required this.category,
    this.image = "",
    this.notes = "",
    required this.type,
  });

  ExpenseModel copyWith({
    String? expenseId,
    String? tripId,
    String? name,
    double? paid,
    double? cost,
    String? currency,
    String? category,
    DateTime? dateTimeAdded,
    DateTime? datePaid,
    String? type,
    List<String>? tags,
    String? notes,
    String? image,
  }) {
    return ExpenseModel(
      expenseId: expenseId ?? this.expenseId,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      type: type ?? this.type,
      cost: cost ?? this.cost,
      paid: paid ?? this.paid,
      dateTimeAdded: dateTimeAdded ?? this.dateTimeAdded,
      datePaid: datePaid ?? this.datePaid,
      currency: currency ?? this.currency,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      image: image ?? this.image,
      category: category ?? this.category,
    );
  }
}
