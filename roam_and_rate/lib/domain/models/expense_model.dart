class ExpenseModel {
  final String? expenseId;
  final String tripId;
  final String participantId;
  final String name;
  final String? targetCurrency;
  final String? baseCurrency;
  final int? basePaidAmountMinor;
  final int? baseCostAmountMinor;
  final int? targetPaidAmountMinor;
  final int? targetCostAmountMinor;
  final double? exchangeRate;
  final DateTime? exchangeRateDate;
  final double paid;
  final double cost;
  final String currency;
  final String category;
  final bool toBeSplit;
  final List<String>? splitParticipants;
  final bool isNotBudget;
  final DateTime dateTimeAdded;
  final DateTime datePaid;
  final String type;
  final List<String> tags;
  final String notes;
  final String image;
  final String conversionStatus;
  final DateTime? lastUpdated;
  final String? location;

  ExpenseModel({
    required this.name,
    required this.paid,
    required this.cost,
    this.expenseId,
    required this.tripId,
    required this.participantId,
    this.targetCurrency,
    this.targetPaidAmountMinor,
    this.targetCostAmountMinor,
    this.basePaidAmountMinor,
    this.baseCostAmountMinor,
    this.exchangeRate,
    this.exchangeRateDate,
    required this.dateTimeAdded,
    required this.datePaid,
    required this.currency,
    this.baseCurrency,
    required this.toBeSplit,
    this.splitParticipants,
    required this.isNotBudget,
    this.tags = const [],
    required this.category,
    this.image = "",
    this.notes = "",
    required this.type,
    this.lastUpdated,
    required this.conversionStatus,
    this.location
  });

  ExpenseModel copyWith({
    String? expenseId,
    String? tripId,
    String? participantId,
    String? name,
    double? paid,
    double? cost,
    String? targetCurrency,
    int? targetPaidAmountMinor,
    int? targetCostAmountMinor,
    int? basePaidAmountMinor,
    int? baseCostAmountMinor,
    double? exchangeRate,
    DateTime? exchangeRateDate,
    String? currency,
    String? baseCurrency,
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
    String? conversionStatus,
    String? location,
    List<String>? splitParticipants,

  }) {
    return ExpenseModel(
      expenseId: expenseId ?? this.expenseId,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      type: type ?? this.type,
      paid: paid ?? this.paid,
      cost: cost ?? this.cost,
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
      targetCurrency: targetCurrency ?? this.targetCurrency,
      targetPaidAmountMinor: targetPaidAmountMinor ?? this.targetPaidAmountMinor,
      targetCostAmountMinor: targetCostAmountMinor ?? this.targetCostAmountMinor,
      basePaidAmountMinor: basePaidAmountMinor ?? this.basePaidAmountMinor,
      baseCostAmountMinor: baseCostAmountMinor ?? this.baseCostAmountMinor,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      exchangeRateDate: exchangeRateDate ?? this.exchangeRateDate,
      conversionStatus: conversionStatus ?? this.conversionStatus,
      location: location ?? this.location,
      splitParticipants: splitParticipants ?? this.splitParticipants,
    );
  }
}
