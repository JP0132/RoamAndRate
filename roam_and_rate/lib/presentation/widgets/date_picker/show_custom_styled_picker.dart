import 'package:flutter/material.dart';
import 'package:roam_and_rate/core/utils/constants/colours.dart';
import 'package:roam_and_rate/domain/models/date_picker_model.dart';
import 'package:roam_and_rate/presentation/widgets/common/customised_date_picker.dart';

class ShowPicker {
  static Future<void> showCustomStyledPicker(
    BuildContext context,
    DateTime? selectedDate,
    Function setDate,
  ) async {
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
                primaryColor: CustomColours.darkPrimary,
                backgroundColor: CustomColours.darkSurface,
                textColor: CustomColours.darkPrimaryText,
                selectedTextColor: Colors.black,
                disabledTextColor: CustomColours.darkPrimary,
                borderColor: CustomColours.darkBackground,
                todayColor: CustomColours.darkError,
                hoverColor: CustomColours.darkSecondarySurface,
                borderRadius: 20.0,
                headerTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CustomColours.darkPrimary,
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
                primaryColor: CustomColours.darkPrimary,
                backgroundColor: CustomColours.darkSurface,
                textColor: CustomColours.darkPrimaryText,
                selectedTextColor: Colors.black,
                disabledTextColor: CustomColours.darkPrimary,
                borderColor: CustomColours.darkBackground,
                todayColor: CustomColours.darkError,
                hoverColor: CustomColours.darkSecondarySurface,
                borderRadius: 20.0,
                headerTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: CustomColours.darkPrimary,
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
                rangeColor: CustomColours.darkPrimaryVariant,
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
