import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/themes/custom_colours.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/customised_date_picker.dart';

class ShowPicker {
  static Future<void> showCustomStyledPicker(
    BuildContext context,
    DateTime? selectedDate,
    Function setDate,
  ) async {
    final custom = Theme.of(context).extension<CustomColours>()!;

    // Unfocus anything currently focused
    FocusScope.of(context).unfocus();

    // Open the date picker dialog
    final date = await showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // Prevent the dialog itself from requesting focus
        return FocusScope(
          canRequestFocus: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomDatePicker(
              config: DatePickerConfig(
                primaryColor: custom.primary,
                backgroundColor: custom.surface,
                textColor: custom.primaryText,
                selectedTextColor: Colors.black,
                disabledTextColor: custom.primary,
                borderColor: custom.background,
                todayColor: custom.error,
                hoverColor: custom.secondarySurface,
                borderRadius: 20.0,
                headerTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: custom.primary,
                ),
                dayTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                monthTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                yearTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                enableManualEdit: true,
              ),
              initialDate: selectedDate,
              onDateSelected: (date) {
                Navigator.of(context).pop(date);
              },
            ),
          ),
        );
      },
    );

    // Delay a frame to ensure Flutter doesn't restore previous focus
    await Future.delayed(Duration.zero);
    FocusScope.of(context).unfocus();

    // Update selected date
    if (date != null) {
      setDate(date);
    }
  }

  static Future<void> showEnhancedRangeDatePicker(
    BuildContext context,
    DateTimeRange? selectedRange,
    Function onRangeSelected,
  ) async {
    final custom = Theme.of(context).extension<CustomColours>()!;

    FocusScope.of(context).unfocus();

    final range = await showDialog<DateTimeRange>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return FocusScope(
          canRequestFocus: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: CustomDatePicker(
              config: DatePickerConfig(
                isRangePicker: true,
                primaryColor: custom.primary,
                backgroundColor: custom.surface,
                textColor: custom.primaryText,
                selectedTextColor: Colors.black,
                disabledTextColor: custom.primary,
                borderColor: custom.background,
                todayColor: custom.error,
                hoverColor: custom.secondarySurface,
                borderRadius: 20.0,
                headerTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: custom.primary,
                ),
                dayTextStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                monthTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                yearTextStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                enableManualEdit: true,
                rangeColor: custom.primaryVariant,
              ),
              initialRange: selectedRange,
              onRangeSelected: (range) {
                Navigator.of(context).pop(range);
              },

            ),
          ),
        );
      },
    );

    // Delay a frame to ensure Flutter doesn't restore previous focus
    await Future.delayed(Duration.zero);
    FocusScope.of(context).unfocus();

    if (range != null) {
      onRangeSelected(range);
    }
  }
}
