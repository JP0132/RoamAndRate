class ExpenseModel {
  final String? expenseId;
  final String tripId;
  final String participantId;
  final String name;
  final double paid;
  final double cost;
  final String currency;
  final String category;
  final bool toBeSplit;
  final bool isNotBudget;
  final DateTime dateTimeAdded;
  final DateTime datePaid;
  final String type;
  final List<String> tags;
  final String notes;
  final String image;
  final DateTime? lastUpdated;

  ExpenseModel({
    required this.name,
    this.expenseId,
    required this.tripId,
    required this.participantId,
    required this.paid,
    required this.cost,
    required this.dateTimeAdded,
    required this.datePaid,
    required this.currency,
    required this.toBeSplit,
    required this.isNotBudget,
    this.tags = const [],
    required this.category,
    this.image = "",
    this.notes = "",
    required this.type,
    this.lastUpdated,
  });

  ExpenseModel copyWith({
    String? expenseId,
    String? tripId,
    String? participantId,
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
    bool? toBeSplit,
    bool? isNotBudget,
    DateTime? lastUpdated,
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
      participantId: participantId ?? this.participantId,
      toBeSplit: toBeSplit ?? this.toBeSplit,
      isNotBudget: isNotBudget ?? this.isNotBudget,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
