// date_picker_config.dart
import 'package:flutter/material.dart';

enum DatePickerViewMode { day, month, year }

class DatePickerConfig {
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Color selectedTextColor;
  final Color disabledTextColor;
  final Color borderColor;
  final Color rangeColor;
  final Color rangeTextColor;
  final Color todayColor;
  final Color hoverColor;
  final TextStyle headerTextStyle;
  final TextStyle dayTextStyle;
  final TextStyle monthTextStyle;
  final TextStyle yearTextStyle;
  final double borderRadius;
  final bool enableManualEdit;
  final bool isRangePicker;
  final DateTime? minDate;
  final DateTime? maxDate;

  const DatePickerConfig({
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.rangeTextColor = Colors.black,
    this.textColor = Colors.black87,
    this.selectedTextColor = Colors.white,
    this.disabledTextColor = Colors.grey,
    this.borderColor = Colors.grey,
    this.rangeColor = const Color(0xFFE3F2FD),
    this.todayColor = Colors.orange,
    this.hoverColor = const Color(0xFFF5F5F5),
    this.headerTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    this.dayTextStyle = const TextStyle(fontSize: 14),
    this.monthTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.yearTextStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    this.borderRadius = 12.0,
    this.enableManualEdit = true,
    this.isRangePicker = false,
    this.minDate,
    this.maxDate,
  });

  DatePickerConfig copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? textColor,
    Color? selectedTextColor,
    Color? disabledTextColor,
    Color? borderColor,
    Color? rangeColor,
    Color? rangeTextColor,
    Color? todayColor,
    Color? hoverColor,
    TextStyle? headerTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? monthTextStyle,
    TextStyle? yearTextStyle,
    double? borderRadius,
    bool? enableManualEdit,
    bool? isRangePicker,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return DatePickerConfig(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
      borderColor: borderColor ?? this.borderColor,
      rangeColor: rangeColor ?? this.rangeColor,
      rangeTextColor: rangeTextColor ?? this.rangeTextColor,
      todayColor: todayColor ?? this.todayColor,
      hoverColor: hoverColor ?? this.hoverColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      yearTextStyle: yearTextStyle ?? this.yearTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      enableManualEdit: enableManualEdit ?? this.enableManualEdit,
      isRangePicker: isRangePicker ?? this.isRangePicker,
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
    );
  }
}
