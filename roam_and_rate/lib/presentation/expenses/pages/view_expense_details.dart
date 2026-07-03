import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/core/utils/constants/currency_data.dart';
import 'package:roam_and_rate/core/utils/helper/helper_functions.dart';
import 'package:roam_and_rate/domain/models/expense_model.dart';
import 'package:roam_and_rate/domain/models/participant_model.dart';
import 'package:roam_and_rate/domain/models/trip_model.dart';
import 'package:roam_and_rate/presentation/expenses/helpers/expense_helper_functions.dart';

class ViewExpensePage extends StatelessWidget {
  final ExpenseModel expense;
  final TripModel? tripDetails;
  final List<ParticipantModel> participants;

  const ViewExpensePage({
    super.key,
    required this.expense,
    this.tripDetails,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    final custom = Theme.of(context).extension<CustomColours>()!;
    final baseSymbol = CurrencyData.currencySymbolFromCode(
      expense.baseCurrency!,
    );
    final targetSymbol = expense.targetCurrency != null
        ? CurrencyData.currencySymbolFromCode(expense.targetCurrency!)
        : '';

    return Scaffold(
      backgroundColor: custom.background,
      appBar: AppBar(
        title: Text(expense.name),
        backgroundColor: custom.primary,
        foregroundColor: custom.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card: Category + Name + Date
            _buildHeaderCard(custom),
            const SizedBox(height: 20),

            // Amount Card
            _buildAmountCard(custom, baseSymbol, targetSymbol),
            const SizedBox(height: 20),

            // Details Card
            _buildDetailsCard(custom),
            const SizedBox(height: 20),

            // Tags
            if (expense.tags.isNotEmpty) _buildTagsSection(custom),
            if (expense.tags.isNotEmpty) const SizedBox(height: 20),

            // Notes
            if (expense.notes.isNotEmpty) _buildNotesCard(custom),

            // Receipts (OR whatever image the user uploaded)
            if (expense.image.isNotEmpty ||
                (expense.location != null && expense.location!.isNotEmpty)) ...[
              const SizedBox(height: 20),
              _buildMediaCard(custom),
            ],
          ],
        ),
      ),
    );
  }

  // Header with category icon, name, and date
  Widget _buildHeaderCard(CustomColours custom) {
    return Card(
      color: custom.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: custom.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Helperfunctions.getCatIcon(expense.category),
                color: custom.background,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: custom.primaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(expense.datePaid),
                    style: TextStyle(fontSize: 14, color: custom.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Amounts section with, base & target, exchange rate
  Widget _buildAmountCard(
    CustomColours custom,
    String baseSymbol,
    String targetSymbol,
  ) {
    final bool hasConversion =
        expense.targetPaidAmountMinor != null &&
        expense.exchangeRate != null &&
        expense.exchangeRate != 1.0;

    return Card(
      color: custom.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AMOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: custom.secondaryText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAmountTile(
                    label: 'Paid',
                    symbol: baseSymbol,
                    amountMinor: expense.basePaidAmountMinor!,
                    currency: expense.baseCurrency!,
                    custom: custom,
                    isMain: true,
                  ),
                ),
                if (hasConversion) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: custom.secondaryText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildAmountTile(
                      label: 'Converted',
                      symbol: targetSymbol,
                      amountMinor: expense.targetPaidAmountMinor!,
                      currency: expense.targetCurrency!,
                      custom: custom,
                      isMain: false,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAmountTile(
                    label: 'Cost (Base)',
                    symbol: baseSymbol,
                    amountMinor: expense.baseCostAmountMinor!,
                    currency: expense.baseCurrency!,
                    custom: custom,
                    isMain: true,
                  ),
                ),
                if (hasConversion) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: custom.secondaryText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildAmountTile(
                      label: 'Cost (Converted)',
                      symbol: targetSymbol,
                      amountMinor: expense.targetCostAmountMinor!,
                      currency: expense.targetCurrency!,
                      custom: custom,
                      isMain: false,
                    ),
                  ),
                ],
              ],
            ),
            if (hasConversion && expense.exchangeRate != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.currency_exchange,
                label: 'Exchange Rate',
                value:
                    '$baseSymbol 1  = $targetSymbol ${expense.exchangeRate!.toStringAsFixed(4)}',
                custom: custom,
              ),
              if (expense.exchangeRateDate != null)
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Rate Date',
                  value: DateFormat(
                    'dd MMM yyyy',
                  ).format(expense.exchangeRateDate!),
                  custom: custom,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountTile({
    required String label,
    required String symbol,
    required int amountMinor,
    required String currency,
    required CustomColours custom,
    required bool isMain,
  }) {
    final amountDisplay = getExpenseDisplay(amountMinor, currency);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: custom.secondaryText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$symbol$amountDisplay',
          style: TextStyle(
            fontSize: isMain ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: custom.primaryText,
          ),
        ),
      ],
    );
  }

  // General details in a list
  Widget _buildDetailsCard(CustomColours custom) {
    return Card(
      color: custom.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DETAILS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: custom.secondaryText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            if (!expense.toBeSplit)
              _buildInfoRow(
                icon: Icons.person,
                label: 'Payee',
                value: Helperfunctions.getParticipantName(
                  participants,
                  expense.participantId,
                ),
                custom: custom,
              ),
            _buildInfoRow(
              icon: Icons.category,
              label: 'Category',
              value: expense.category,
              custom: custom,
            ),
            _buildInfoRow(
              icon: Icons.receipt_long,
              label: 'Type',
              value: expense.type,
              custom: custom,
            ),
            _buildInfoRow(
              icon: Icons.people,
              label: 'Split',
              value: expense.toBeSplit
                  ? (expense.splitParticipants
                            ?.map((p) {
                              return Helperfunctions.getParticipantName(
                                participants,
                                p,
                              );
                            })
                            .join(', ') ??
                        'Everyone')
                  : 'Not split',
              custom: custom,
            ),
            _buildInfoRow(
              icon: Icons.account_balance_wallet,
              label: 'Budget',
              value: expense.isNotBudget ? 'Excluded' : 'Included',
              custom: custom,
            ),
            if (expense.location != null && expense.location!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Location',
                value: expense.location!,
                custom: custom,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required CustomColours custom,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: custom.secondaryText),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: custom.secondaryText)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: custom.primaryText,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Tags as chips
  Widget _buildTagsSection(CustomColours custom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAGS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: custom.secondaryText,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: expense.tags
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  backgroundColor: custom.primary.withOpacity(0.15),
                  labelStyle: TextStyle(
                    color: custom.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // Notes card
  //TODO: Make it bigger maybe
  Widget _buildNotesCard(CustomColours custom) {
    return Card(
      color: custom.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NOTES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: custom.secondaryText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              expense.notes,
              style: TextStyle(
                fontSize: 15,
                color: custom.primaryText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Image / Receipt placeholder (if you want to show it)
  Widget _buildMediaCard(CustomColours custom) {
    return Card(
      color: custom.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MEDIA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: custom.secondaryText,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            if (expense.image.isNotEmpty) ...[
              Builder(
                builder: (context) {
                  final file = File(expense.image);
                  if (file.existsSync()) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.broken_image,
                          size: 48,
                          color: custom.secondaryText,
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: custom.secondaryText,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Image not found',
                            style: TextStyle(color: custom.secondaryText),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
            
          ],
        ),
      ),
    );
  }
}
