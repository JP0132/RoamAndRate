import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/application/theme/theme_cubit.dart';
import 'package:roam_and_rate/core/themes/app_theme_mode.dart';

class ThemePickerWidget extends StatelessWidget {
  const ThemePickerWidget({super.key});

  // Give each theme a display name + preview colour
  static const _themes = {
    AppThemeMode.coffee: ('Coffee',  Color(0xFFD4956A)),
    AppThemeMode.darkGrayGreen: ('DarkGrayGreen',  Color(0xFFc5ee7e)),
    
  };

  @override
  Widget build(BuildContext context) {
    final current = context.watch<ThemeCubit>().state;

    return Row(
      children: _themes.entries.map((entry) {
        final isSelected = entry.key == current;
        return GestureDetector(
          onTap: () => context.read<ThemeCubit>().setTheme(entry.key),
          child: Tooltip(
            message: entry.value.$1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: isSelected ? 36 : 28,
              height: isSelected ? 36 : 28,
              decoration: BoxDecoration(
                color: entry.value.$2,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}