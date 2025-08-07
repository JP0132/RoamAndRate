// custom_date_picker.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:roam_and_rate/models/date_picker_model.dart';
import 'package:roam_and_rate/widgets/date_input_formatter.dart';

class CustomDatePicker extends StatefulWidget {
  final DatePickerConfig config;
  final DateTime? initialDate;
  final DateTimeRange? initialRange;
  final Function(DateTime)? onDateSelected;
  final Function(DateTimeRange)? onRangeSelected;

  const CustomDatePicker({
    super.key,
    required this.config,
    this.initialDate,
    this.initialRange,
    this.onDateSelected,
    this.onRangeSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();

  /// Show single date picker as popup
  static Future<DateTime?> showSingleDatePicker({
    required BuildContext context,
    DatePickerConfig? config,
    DateTime? initialDate,
  }) async {
    DateTime? selectedDate;

    await showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config?.borderRadius ?? 12.0),
            ),
            elevation: 8,
            child: CustomDatePicker(
              config: (config ?? const DatePickerConfig()).copyWith(
                isRangePicker: false,
              ),
              initialDate: initialDate,
              onDateSelected: (date) {
                selectedDate = date;
                Navigator.of(context).pop();
              },
            ),
          ),
    );

    return selectedDate;
  }

  /// Show range date picker as popup
  static Future<DateTimeRange?> showRangeDatePicker({
    required BuildContext context,
    DatePickerConfig? config,
    DateTimeRange? initialRange,
  }) async {
    DateTimeRange? selectedRange;

    await showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(config?.borderRadius ?? 12.0),
            ),
            elevation: 8,
            child: CustomDatePicker(
              config: (config ?? const DatePickerConfig()).copyWith(
                isRangePicker: true,
              ),
              initialRange: initialRange,
              onRangeSelected: (range) {
                selectedRange = range;
                Navigator.of(context).pop();
              },
            ),
          ),
    );

    return selectedRange;
  }
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _currentMonth;
  late int _currentYear;
  DateTime? _selectedDate;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  bool _isManualEditMode = false;
  late DateTime _today;
  DatePickerViewMode _viewMode = DatePickerViewMode.day;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _currentMonth = DateTime(_today.year, _today.month);
    _currentYear = _today.year;

    if (widget.config.isRangePicker) {
      if (widget.initialRange != null) {
        _rangeStart = widget.initialRange!.start;
        _rangeEnd = widget.initialRange!.end;
        _currentMonth = DateTime(_rangeStart!.year, _rangeStart!.month);
        _currentYear = _rangeStart!.year;
        _updateRangeControllers();
      }
    } else {
      if (widget.initialDate != null) {
        _selectedDate = widget.initialDate;
        _currentMonth = DateTime(_selectedDate!.year, _selectedDate!.month);
        _currentYear = _selectedDate!.year;
        _updateDateController();
      }
    }
  }

  void _updateDateController() {
    if (_selectedDate != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }
  }

  void _updateRangeControllers() {
    if (_rangeStart != null) {
      _startDateController.text = DateFormat('dd/MM/yyyy').format(_rangeStart!);
    }
    if (_rangeEnd != null) {
      _endDateController.text = DateFormat('dd/MM/yyyy').format(_rangeEnd!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.config.backgroundColor,
        borderRadius: BorderRadius.circular(widget.config.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 16),
            _buildHeader(),
            const SizedBox(height: 16),
            if (widget.config.enableManualEdit &&
                _viewMode == DatePickerViewMode.day)
              _buildManualEditToggle(),
            const SizedBox(height: 8),
            if (_isManualEditMode && _viewMode == DatePickerViewMode.day)
              _buildManualEditFields()
            else
              _buildCurrentView(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          widget.config.isRangePicker ? Icons.date_range : Icons.calendar_today,
          color: widget.config.primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          widget.config.isRangePicker ? 'Select Date Range' : 'Select Date',
          style: widget.config.headerTextStyle.copyWith(
            color: widget.config.textColor,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _canNavigateBack() ? () => _navigateBack() : null,
          icon: Icon(
            Icons.chevron_left,
            color:
                _canNavigateBack()
                    ? widget.config.primaryColor
                    : widget.config.disabledTextColor,
            size: 28,
          ),
          style: IconButton.styleFrom(
            backgroundColor: widget.config.primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: _onHeaderTapped,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: widget.config.hoverColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getHeaderText(),
                textAlign: TextAlign.center,
                style: widget.config.headerTextStyle.copyWith(
                  color: widget.config.textColor,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _canNavigateForward() ? () => _navigateForward() : null,
          icon: Icon(
            Icons.chevron_right,
            color:
                _canNavigateForward()
                    ? widget.config.primaryColor
                    : widget.config.disabledTextColor,
            size: 28,
          ),
          style: IconButton.styleFrom(
            backgroundColor: widget.config.primaryColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentView() {
    switch (_viewMode) {
      case DatePickerViewMode.day:
        return _buildCalendar();
      case DatePickerViewMode.month:
        return _buildMonthView();
      case DatePickerViewMode.year:
        return _buildYearView();
    }
  }

  Widget _buildMonthView() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return SizedBox(
      height: 280,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isCurrentMonth =
              _currentMonth.month == month &&
              _currentMonth.year == _currentYear;
          final isSelectedMonth =
              _selectedDate?.month == month &&
              _selectedDate?.year == _currentYear;

          return GestureDetector(
            onTap: () => _onMonthSelected(month),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSelectedMonth || isCurrentMonth
                        ? widget.config.primaryColor
                        : widget.config.hoverColor,
                borderRadius: BorderRadius.circular(8),
                border:
                    isCurrentMonth && !isSelectedMonth
                        ? Border.all(
                          color: widget.config.primaryColor,
                          width: 2,
                        )
                        : null,
              ),
              child: Center(
                child: Text(
                  months[index].substring(0, 3),
                  style: widget.config.monthTextStyle.copyWith(
                    color:
                        isSelectedMonth || isCurrentMonth
                            ? widget.config.selectedTextColor
                            : widget.config.textColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearView() {
    final startYear = (_currentYear ~/ 12) * 12;
    final years = List.generate(12, (index) => startYear + index);

    return SizedBox(
      height: 280,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final year = years[index];
          final isCurrentYear = _currentYear == year;
          final isSelectedYear = _selectedDate?.year == year;
          final isTodayYear = _today.year == year;

          return GestureDetector(
            onTap: () => _onYearSelected(year),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSelectedYear || isCurrentYear
                        ? widget.config.primaryColor
                        : widget.config.hoverColor,
                borderRadius: BorderRadius.circular(8),
                border:
                    isTodayYear && !isSelectedYear && !isCurrentYear
                        ? Border.all(color: widget.config.todayColor, width: 2)
                        : null,
              ),
              child: Center(
                child: Text(
                  year.toString(),
                  style: widget.config.yearTextStyle.copyWith(
                    color:
                        isSelectedYear || isCurrentYear
                            ? widget.config.selectedTextColor
                            : widget.config.textColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildManualEditToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: widget.config.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.edit, size: 18, color: widget.config.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Manual Edit',
              style: TextStyle(
                color: widget.config.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Switch(
            value: _isManualEditMode,
            onChanged: (value) => setState(() => _isManualEditMode = value),
            activeColor: widget.config.primaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildManualEditFields() {
    if (widget.config.isRangePicker) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateTextField(
                  controller: _startDateController,
                  label: 'Start Date',
                  onChanged: _onStartDateManualChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateTextField(
                  controller: _endDateController,
                  label: 'End Date',
                  onChanged: _onEndDateManualChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    } else {
      return Column(
        children: [
          _buildDateTextField(
            controller: _dateController,
            label: 'Date',
            onChanged: _onDateManualChanged,
          ),
          const SizedBox(height: 16),
        ],
      );
    }
  }

  Widget _buildDateTextField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'DD/MM/YYYY',
        prefixIcon: Icon(
          Icons.calendar_today,
          color: widget.config.primaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.config.borderRadius),
          borderSide: BorderSide(color: widget.config.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.config.borderRadius),
          borderSide: BorderSide(color: widget.config.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: widget.config.backgroundColor,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        LengthLimitingTextInputFormatter(10),
        DateInputFormatter(),
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        _buildWeekDaysHeader(),
        const SizedBox(height: 12),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildWeekDaysHeader() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children:
            weekDays
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: widget.config.dayTextStyle.copyWith(
                          color: widget.config.disabledTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final firstWeekday = (firstDayOfMonth.weekday - 1) % 7;

    final days = <Widget>[];

    for (int i = 0; i < firstWeekday; i++) {
      days.add(const SizedBox(height: 40));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      days.add(_buildDayCell(date));
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      childAspectRatio: 1.2,
      children: days,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isSelected =
        widget.config.isRangePicker
            ? _isDateInRange(date)
            : _selectedDate != null && _isSameDay(date, _selectedDate!);

    final isRangeStart =
        widget.config.isRangePicker &&
        _rangeStart != null &&
        _isSameDay(date, _rangeStart!);
    final isRangeEnd =
        widget.config.isRangePicker &&
        _rangeEnd != null &&
        _isSameDay(date, _rangeEnd!);
    final isInRange =
        widget.config.isRangePicker &&
        _isDateInRange(date) &&
        !isRangeStart &&
        !isRangeEnd;
    final isToday = _isSameDay(date, _today);

    Color? backgroundColor;
    Color? textColor = widget.config.textColor;
    Border? border;

    if (isRangeStart ||
        isRangeEnd ||
        (!widget.config.isRangePicker && isSelected)) {
      backgroundColor = widget.config.primaryColor;
      textColor = widget.config.selectedTextColor;
    } else if (isInRange) {
      backgroundColor = widget.config.rangeColor;
      textColor = widget.config.rangeTextColor;
    } else if (isToday) {
      border = Border.all(color: widget.config.todayColor, width: 2);
      textColor = widget.config.todayColor;
    }

    return GestureDetector(
      onTap: () => _onDateTapped(date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: widget.config.dayTextStyle.copyWith(
              color: textColor,
              fontWeight:
                  isToday || isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button for navigation between views
        if (_viewMode != DatePickerViewMode.day)
          Flexible(
            child: TextButton.icon(
              onPressed: _goBackToParentView,
              icon: Icon(Icons.arrow_back, size: 16),
              label: Text(
                _getBackButtonText(),
                overflow: TextOverflow.ellipsis,
              ),
              style: TextButton.styleFrom(
                foregroundColor: widget.config.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                minimumSize: Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          )
        else
          const SizedBox.shrink(),

        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  minimumSize: Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: widget.config.disabledTextColor,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: _canConfirm() ? _onConfirmPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  foregroundColor: widget.config.selectedTextColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  minimumSize: Size(0, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      widget.config.borderRadius,
                    ),
                  ),
                  elevation: 2,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Navigation methods
  String _getHeaderText() {
    switch (_viewMode) {
      case DatePickerViewMode.day:
        return DateFormat('MMMM yyyy').format(_currentMonth);
      case DatePickerViewMode.month:
        return _currentYear.toString();
      case DatePickerViewMode.year:
        final startYear = (_currentYear ~/ 12) * 12;
        final endYear = startYear + 11;
        return '$startYear - $endYear';
    }
  }

  String _getBackButtonText() {
    switch (_viewMode) {
      case DatePickerViewMode.month:
        return 'Days';
      case DatePickerViewMode.year:
        return 'Months';
      case DatePickerViewMode.day:
        return '';
    }
  }

  void _onHeaderTapped() {
    setState(() {
      switch (_viewMode) {
        case DatePickerViewMode.day:
          _viewMode = DatePickerViewMode.month;
          break;
        case DatePickerViewMode.month:
          _viewMode = DatePickerViewMode.year;
          break;
        case DatePickerViewMode.year:
          // Already at top level
          break;
      }
    });
  }

  void _goBackToParentView() {
    setState(() {
      switch (_viewMode) {
        case DatePickerViewMode.month:
          _viewMode = DatePickerViewMode.day;
          break;
        case DatePickerViewMode.year:
          _viewMode = DatePickerViewMode.month;
          break;
        case DatePickerViewMode.day:
          // Already at bottom level
          break;
      }
    });
  }

  bool _canNavigateBack() {
    switch (_viewMode) {
      case DatePickerViewMode.day:
        return true;
      case DatePickerViewMode.month:
        return _currentYear > 1900;
      case DatePickerViewMode.year:
        return true;
    }
  }

  bool _canNavigateForward() {
    switch (_viewMode) {
      case DatePickerViewMode.day:
        return true;
      case DatePickerViewMode.month:
        return _currentYear < 2100;
      case DatePickerViewMode.year:
        return true;
    }
  }

  void _navigateBack() {
    setState(() {
      switch (_viewMode) {
        case DatePickerViewMode.day:
          // Prevent month from going below 1
          if (_currentMonth.month == 1) {
            _currentMonth = DateTime(_currentMonth.year - 1, 12);
          } else {
            _currentMonth = DateTime(
              _currentMonth.year,
              _currentMonth.month - 1,
            );
          }
          break;
        case DatePickerViewMode.month:
          _currentYear--;
          _currentMonth = DateTime(_currentYear, _currentMonth.month);
          break;
        case DatePickerViewMode.year:
          _currentYear -= 12;
          break;
      }
    });
  }

  void _navigateForward() {
    setState(() {
      switch (_viewMode) {
        case DatePickerViewMode.day:
          // Prevent month from going above 12
          if (_currentMonth.month == 12) {
            _currentMonth = DateTime(_currentMonth.year + 1, 1);
          } else {
            _currentMonth = DateTime(
              _currentMonth.year,
              _currentMonth.month + 1,
            );
          }
          break;
        case DatePickerViewMode.month:
          _currentYear++;
          _currentMonth = DateTime(_currentYear, _currentMonth.month);
          break;
        case DatePickerViewMode.year:
          _currentYear += 12;
          break;
      }
    });
  }

  void _onMonthSelected(int month) {
    setState(() {
      _currentMonth = DateTime(_currentYear, month);
      _viewMode = DatePickerViewMode.day;
    });
  }

  void _onYearSelected(int year) {
    setState(() {
      _currentYear = year;
      _currentMonth = DateTime(year, _currentMonth.month);
      _viewMode = DatePickerViewMode.month;
    });
  }

  bool _canConfirm() {
    if (_viewMode != DatePickerViewMode.day) return false;

    if (widget.config.isRangePicker) {
      return _rangeStart != null && _rangeEnd != null;
    } else {
      return _selectedDate != null;
    }
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      if (widget.config.isRangePicker) {
        if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
          _rangeStart = date;
          _rangeEnd = null;
        } else if (_rangeEnd == null) {
          if (date.isBefore(_rangeStart!)) {
            _rangeEnd = _rangeStart;
            _rangeStart = date;
          } else {
            _rangeEnd = date;
          }
        }
        _updateRangeControllers();
      } else {
        _selectedDate = date;
        _updateDateController();
      }
    });
  }

  void _onConfirmPressed() {
    if (widget.config.isRangePicker) {
      if (_rangeStart != null && _rangeEnd != null) {
        widget.onRangeSelected?.call(
          DateTimeRange(start: _rangeStart!, end: _rangeEnd!),
        );
      }
    } else {
      if (_selectedDate != null) {
        widget.onDateSelected?.call(_selectedDate!);
      }
    }
  }

  void _onDateManualChanged(String value) {
    if (value.length == 10) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(value);
        setState(() {
          _selectedDate = date;
          _currentMonth = DateTime(date.year, date.month);
          _currentYear = date.year;
        });
      } catch (e) {
        // Invalid date format
      }
    }
  }

  void _onStartDateManualChanged(String value) {
    if (value.length == 10) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(value);
        setState(() {
          _rangeStart = date;
          _currentMonth = DateTime(date.year, date.month);
          _currentYear = date.year;
        });
      } catch (e) {
        // Invalid date format
      }
    }
  }

  void _onEndDateManualChanged(String value) {
    if (value.length == 10) {
      try {
        final date = DateFormat('dd/MM/yyyy').parse(value);
        setState(() {
          _rangeEnd = date;
        });
      } catch (e) {
        // Invalid date format
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateInRange(DateTime date) {
    if (_rangeStart == null) return false;
    if (_rangeEnd == null) return _isSameDay(date, _rangeStart!);

    return (date.isAfter(_rangeStart!) || _isSameDay(date, _rangeStart!)) &&
        (date.isBefore(_rangeEnd!) || _isSameDay(date, _rangeEnd!));
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
