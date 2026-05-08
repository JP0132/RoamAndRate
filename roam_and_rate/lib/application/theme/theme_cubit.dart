import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roam_and_rate/core/themes/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit() : super(AppThemeMode.darkGrayGreen) {
    _loadSavedTheme();
  }

  Future<void> setTheme(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', mode.name);
    emit(mode);
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme');
    if (saved != null) {
      final match = AppThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppThemeMode.darkGrayGreen,
      );
      emit(match);
    }
  }
}